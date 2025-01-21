package com.babymonitoring.simulationplayer;

import com.babymonitoring.simulationplayer.models.*;
import com.mathworks.engine.MatlabEngine;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.Console;
import java.nio.file.Paths;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.springframework.scheduling.annotation.Async;

public class ProdSimulation {
    private static int timeIndex = 0;
    private static int simcount = 1;
    private static int prevTimeIndex = 0;
    private static MatlabEngine eng;
    private static Timer timer;
    private static XYSeries O2;
    private static XYSeries fhr;
    private static XYSeries map;
    private static CompletableFuture<Object[]> simPreResults;
    private static Object[] simResults;
    private static boolean endSimulation = false;
    @Async
    public void Chart() {
        try {

            boolean vMother = true;
            boolean vUterus = true;
            boolean vFoetus  = true;
            int vUmbilical = 1;
            boolean vBrain = true;
            int vCAVmodel = 2;
            int vScen = 2;
            boolean vHES = false;
            boolean vPersen  = false;
            boolean vDut = false;
            int vNCycleMax = 300;
            boolean vLamb = false;

            O2 = new XYSeries("O2PResult");
            XYSeriesCollection dataset = new XYSeriesCollection(O2);
            JFreeChart chart = ChartFactory.createXYLineChart(
                    "O2p",
                    "Tijd (s)",
                    "02 liter",
                    dataset,
                    PlotOrientation.VERTICAL,
                    true, true, false
            );
            fhr = new XYSeries("fhr");
            XYSeriesCollection dataset1 = new XYSeriesCollection(fhr);
            JFreeChart chart1 = ChartFactory.createXYLineChart(
                    "fhr",
                    "Tijd (s)",
                    "Amplitude",
                    dataset1,
                    PlotOrientation.VERTICAL,
                    true, true, false
            );
            map = new XYSeries("map");
            XYSeriesCollection dataset2 = new XYSeriesCollection(map);
            JFreeChart chart2 = ChartFactory.createXYLineChart(
                    "map",
                    "Tijd (s)",
                    "Amplitude",
                    dataset2,
                    PlotOrientation.VERTICAL,
                    true, true, false
            );

            JPanel panel = new JPanel(new GridLayout(1, 4));
            panel.add(new ChartPanel(chart));
            panel.add(new ChartPanel(chart1));
            panel.add(new ChartPanel(chart2));

            JFrame frame = new JFrame("Meerdere Grafieken");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.getContentPane().add(panel);

            frame.pack();
            frame.setVisible(true);




            startProductionSimulation(vMother, vUterus,vFoetus,vUmbilical,vBrain,vCAVmodel,vScen,vHES,vPersen,vDut,vNCycleMax, vLamb);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static CompletableFuture<Object[]> getProductionMatlabResultAsync(boolean vMother, boolean vUterus, boolean vFoetus, int vUmbilical, boolean vBrain, int vCAVmodel, int vScen, boolean vHES, boolean vPersen, boolean vDuty, int vNCycleMax, boolean vLamb) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                System.out.println("debug: getProductionMatlabResultAsync");
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
    public void startProductionSimulation(boolean vMother, boolean vUterus, boolean vFoetus, int vUmbilical, boolean vBrain, int vCAVmodel, int vScen, boolean vHES, boolean vPersen, boolean vDuty, int vNCycleMax, boolean vLamb) throws ExecutionException, InterruptedException {
        System.out.println("debug: startProductionSimulation");
        simResults = getProductionMatlabResultAsync(vMother, vUterus, vFoetus,vUmbilical,vBrain, vCAVmodel, vScen, vHES, vPersen, vDuty, vNCycleMax, vLamb).get();
        timer = new Timer(10, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    int xCoord = timeIndex + prevTimeIndex;
                    double yO = correctresult(simResults).o2PResult[timeIndex].o2Pressure;
                    double yfhr = correctresult(simResults).fhrResult[timeIndex].heartRate;
                    double ymap = correctresult(simResults).mapResult[timeIndex].MAP;
                    System.out.println("debug:"+ yO);
                    O2.add(xCoord, yO);
                    fhr.add(xCoord, yfhr);
                    map.add(xCoord, ymap);
                    timeIndex++;

                    if (timeIndex == 2){
                       simPreResults = getProductionMatlabResultAsync(vMother, vUterus, vFoetus,vUmbilical,vBrain, vCAVmodel, vScen, vHES, vPersen, vDuty, vNCycleMax, vLamb);
                    }

                    if ((endSimulation || timeIndex >= 3000)) {
                        if (simPreResults.isDone() && (timeIndex-2 < timeIndex-1)) {
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

    });}

    public FMPResult correctresult(Object[] tempSimResults){
        System.out.println("debug:correctresult");
        Object[] pUt = (Object[]) tempSimResults[0];
        double[] pUtT = (double[]) pUt[0];
        double[] pUtV = (double[]) pUt[1];
        UPResult[] upResults = new UPResult[pUtT.length];
        for (int i = 0; i < pUtT.length; i++) {
            UPResult upResult = new UPResult(pUtT[i], pUtV[i]);
            upResults[i] = upResult;
        }

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
        return fmpResult;
    }



}