package com.babymonitoring.simulationplayer;

import com.babymonitoring.simulationplayer.controllers.MessageController;
import com.babymonitoring.simulationplayer.models.messages.CoordsMessage;
import com.babymonitoring.simulationplayer.models.results.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.mathworks.engine.MatlabEngine;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.List;
import java.util.ArrayList;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.springframework.scheduling.annotation.Async;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

public class Simulation {
    private static double timeIndex = 0;
    private static int simcount = 1;
    private static double prevTimeIndex = 0;
    private static MatlabEngine eng;
    private static Timer timer;
    private static XYSeries series;
    private static CompletableFuture<double[]> simPreResults;
    private static double[] simResults;
    private static boolean endSimulation = false;
    private MessageController controller;

    //@Autowired
    public Simulation(MessageController messageController) {
        this.controller = messageController;
    }

    public static CompletableFuture<double[]> getMatlabResultAsync(double a, double f, double ts, double tsp, double te) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                // Start de MATLAB-engine
                MatlabEngine eng = MatlabEngine.startMatlab();

                String projectDir = Paths.get("").toAbsolutePath().toString();
                String relativePath = projectDir + "\\src\\main\\resources\\scripts\\matlab";
                eng.eval("addpath('" + relativePath.replace("\\", "\\\\") + "')");

                double[] result = eng.feval("testscript", a, f, ts, tsp, te);
                eng.close();
                return result;
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        });
    }

    public void Chart() {
        try {

            // Voer het script uit met invoer n = 4
            /*double a = 2;
            double f = 2;
            double ts = 0;
            double tsp = 0.01;
            double te = 10;*/

            series = new XYSeries("Sinusfunctie");
            XYSeriesCollection dataset = new XYSeriesCollection(series);
            JFreeChart chart = ChartFactory.createXYLineChart(
                    "Sinusbeweging",
                    "Tijd (s)",
                    "Amplitude",
                    dataset,
                    PlotOrientation.VERTICAL,
                    true, true, false
            );

            // Grafiek tonen in een JFrame
            JFrame frame = new JFrame("Sinus Grafiek");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.getContentPane().add(new ChartPanel(chart));
            frame.pack();
            frame.setVisible(true);

            JButton myButton = new JButton("Start Actie");
            frame.add(myButton, BorderLayout.SOUTH);

            myButton.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    System.out.println("Knop is ingedrukt!");
                    endSimulation = true;


                }
            });

            //startSimulation(10, 1000,5,0.5,0,0.01,10, UUID.randomUUID());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Async
    public static void stopSimulation() {
        timer.stop();
    }

    public static boolean simIsinRange(double y) {
        double top = 0;
        double bottom = -1;
        return y > bottom && y < top;
    }

    @Async
    public void startSimulation(int t, int steps, double a, double f, double ts, double tsp, double te, UUID userId) throws ExecutionException, InterruptedException {
        //----- For debug -----
        Chart();
        //---------------------


        simResults = getMatlabResultAsync(a, f, ts, tsp, te).get();
        timer = new Timer(t, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    double xCoord = timeIndex + prevTimeIndex;
                    double yCoord = simResults[(int) timeIndex];

                    //----- For debug -----
                    series.add(xCoord, yCoord); // Series.add( X-as, Y-as )
                    //---------------------

                    //WEBSOCKET
                    //controller.SendCoords(new CoordsMessage(userId, xCoord, yCoord));

                    timeIndex++;

                    if (timeIndex == 2) {
                        simPreResults = getMatlabResultAsync(a + simcount, f, ts, tsp, te);
                    }

                    if ((endSimulation || timeIndex >= steps)) {
                        if (simPreResults.isDone() && (simResults[(int) (timeIndex - 2)] < simResults[(int) (timeIndex - 1)]) && simIsinRange(simResults[(int) timeIndex])) {
                            endSimulation = false;
                            simcount++;
                            prevTimeIndex = timeIndex + prevTimeIndex;
                            timeIndex = 0;
                            simResults = simPreResults.get();
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        });
        timer.start();
    }

    public static CompletableFuture<Object[]> getProductionMatlabResultAsync(boolean vMother, boolean vUterus, boolean vFoetus, int vUmbilical, boolean vBrain, int vCAVmodel, int vScen, boolean vHES, boolean vPersen, boolean vDuty, int vNCycleMax, boolean vLamb) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                // Start de MATLAB-engine
                MatlabEngine eng = MatlabEngine.startMatlab();

                String projectDir = Paths.get("").toAbsolutePath().toString();
                String relativePath = projectDir + "\\src\\main\\resources\\scripts\\matlab\\production";
                eng.eval("addpath('" + relativePath.replace("\\", "\\\\") + "')");

                Object[] result = eng.feval("FMPmodel", vMother ? 1 : 0, vUterus ? 1 : 0, vFoetus ? 1 : 0, vUmbilical, vBrain ? 1 : 0, vCAVmodel, vScen, vHES ? 1 : 0, vPersen ? 1 : 0, vDuty ? 1 : 0, vNCycleMax, vLamb ? 1 : 0);
                eng.close();
                return result;
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        });
    }

    @Async
    public void startProductionSimulation(boolean vMother, boolean vUterus, boolean vFoetus, int vUmbilical, boolean vBrain, int vCAVmodel, int vScen, boolean vHES, boolean vPersen, boolean vDuty, int vNCycleMax, boolean vLamb, UUID userId) throws ExecutionException, InterruptedException {
        //----- For debug -----
        //Chart();
        //---------------------


        Object[] tempSimResults = getProductionMatlabResultAsync(vMother, vUterus, vFoetus, vUmbilical, vBrain, vCAVmodel, vScen, vHES, vPersen, vDuty, vNCycleMax, vLamb).get();
        //timer = new Timer(180, new ActionListener() {
        //    @Override
        //    public void actionPerformed(ActionEvent e) {
        //        try {
        //double xCoord = timeIndex + prevTimeIndex;
        //double yCoord = simResults[(int) timeIndex];

        //System.out.println("COORDS: " + xCoord + ", " + yCoord);


        //----- For debug -----
        //System.out.println("COORDS: " + xCoord + ", " + yCoord);
        //System.out.println(Arrays.toString(simResults));
        Object[] pUt = (Object[]) tempSimResults[0];
        double[] pUtT = (double[]) pUt[0];
        double[] pUtV = (double[]) pUt[1];
        UPResult[] upResults = new UPResult[pUtT.length];
        for (int i = 0; i < pUtT.length; i++) {
            UPResult upResult = new UPResult(pUtT[i], pUtV[i]);
            upResults[i] = upResult;
        }


        Object[] qUt = (Object[]) tempSimResults[1];
        double[] qUtT = (double[]) qUt[0];
        double[] qUtV = (double[]) qUt[1];
        //FHRResult fhrResult = new FHRResult(qUtT, qUtV);

        Object[] pAo = (Object[]) tempSimResults[2];
        double[] pAoT = (double[]) pAo[0];
        double[] pAoV = (double[]) pAo[1];
        O2PResult[] o2PResults = new O2PResult[pAoT.length];
        for (int i = 0; i < pAoT.length; i++) {
            O2PResult o2PResult = new O2PResult(pAoT[i], pAoV[i]);
            o2PResults[i] = o2PResult;
        }

        Object[] MAP = (Object[]) tempSimResults[3];
        double[] MAPT = (double[]) MAP[0];
        double[] MAPV = (double[]) MAP[1];
        MAPResult[] mapResults = new MAPResult[MAPT.length];
        for (int i = 0; i < MAPT.length; i++) {
            MAPResult mapResult = new MAPResult(MAPT[i], MAPV[i]);
            mapResults[i] = mapResult;
        }

        Object[] FHR = (Object[]) tempSimResults[4];
        double[] FHRT = (double[]) FHR[0];
        double[] FHRV = (double[]) FHR[1];
        FHRResult[] fhrResults = new FHRResult[FHRT.length];
        for (int i = 0; i < FHRT.length; i++) {
            FHRResult fhrResult = new FHRResult(FHRT[i], FHRV[i]);
            fhrResults[i] = fhrResult;
        }

        FMPResult fmpResult = new FMPResult(fhrResults, mapResults, o2PResults, upResults);

        //SplitResults(userId, fmpResult);
        CorrectResults(userId, fmpResult);


        //series.add(xCoord, yCoord); // Series.add( X-as, Y-as )
        //            timeIndex += 0.1;
        //            prevTimeIndex = timeIndex + prevTimeIndex;
        //            timeIndex = 0;
        //---------------------

        //----- For WEBSOCKET -----
        //controller.SendCoords(new CoordsMessage(userId, fmpResult));
        //-------------------------

                    /*timeIndex++;

                    if (timeIndex == 2){
                        simResults = getProductionMatlabResultAsync(vMother, vUterus, vFoetus, vUmbilical, vBrain, vCAVmodel, vScen, vHES, vPersen, vDuty, vNCycleMax, vLamb).get();
                    }

                    if ((endSimulation || timeIndex >= steps)) {
                        if (simPreResults.isDone() && (simResults[timeIndex-2] < simResults[timeIndex-1]) && simIsinRange(simResults[timeIndex]) ) {
                            endSimulation = false;
                            simcount++;
                            prevTimeIndex = timeIndex + prevTimeIndex;
                            timeIndex = 0;
                            simResults = simPreResults.get();
                        }
                    }*/
        //        } catch (Exception ex) {
        //            ex.printStackTrace();
        //        }
        //    }
        //});
        //timer.start();
    }

    private void CorrectResults (UUID userId, FMPResult fmpResult) {
        double timeSpanDif = 0.1;
        double uPressureDif = 0.1;


        double timeSpan = 0;
        double uPressure = 0;
        List<UPResult> newList = new ArrayList<>();

        for (int i = 0; i < fmpResult.upResult.length; i++) {
            UPResult result = fmpResult.upResult[i];
            if (i != 0 && i < (fmpResult.upResult.length - 1)) {
                if ((timeSpan + timeSpanDif) < result.timeSpan) {
                    newList.add(result);
                    timeSpan = result.timeSpan;
                    uPressure = result.uPressure;
                }
                else if ((uPressure + uPressureDif) < result.uPressure) {
                    newList.add(result);
                    timeSpan = result.timeSpan;
                    uPressure = result.uPressure;
                }
            }
            else if (i != 0) {
                newList.add(result);
                timeSpan = result.timeSpan;
                uPressure = result.uPressure;
            }
            else {
                timeSpan = result.timeSpan;
                uPressure = result.uPressure;

                newList.add(fmpResult.upResult[i]);
            }
        }

        fmpResult.upResult = newList.toArray(new UPResult[0]);


        //double timeIndex = 0.5;
        //int UPIndex = getTimedIndex(timeIndex, fmpResult.upResult);
        //int O2PIndex = getTimedIndex(timeIndex, fmpResult.o2PResult);
        //int MAPIndex = getTimedIndex(timeIndex, fmpResult.mapResult);
        //int FHRIndex = getTimedIndex(timeIndex, fmpResult.fhrResult);



        ObjectMapper mapper = new ObjectMapper();
        try {
            String json = mapper.writeValueAsString(fmpResult);
            System.out.println(json);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        controller.SendCoords(new CoordsMessage(userId, fmpResult));
    }

//    private void SplitResults (UUID userId, FMPResult fmpResult) {
//        double timeIndex = 0.5;
//
//        //int UPIndex = getTimedIndex(timeIndex, fmpResult.upResult);
//        //int O2PIndex = getTimedIndex(timeIndex, fmpResult.o2PResult);
//        //int MAPIndex = getTimedIndex(timeIndex, fmpResult.mapResult);
//        //int FHRIndex = getTimedIndex(timeIndex, fmpResult.fhrResult);
//
//
//
//        ObjectMapper mapper = new ObjectMapper();
//        try {
//            String json = mapper.writeValueAsString(fmpResult);
//            System.out.println(json);
//        } catch (JsonProcessingException e) {
//            e.printStackTrace();
//        }
//
//        controller.SendCoords(new CoordsMessage(userId, fmpResult));
//    }

    private int getTimedIndex(double timeIndex, Result[] array) {
        int index = -1;

        for (int i = 0; i < array.length; i++) {
            if (array[i].timeSpan > timeIndex) {
                return i; // Return the first index where value is greater than x
            }
        }
        return index;
    }
}