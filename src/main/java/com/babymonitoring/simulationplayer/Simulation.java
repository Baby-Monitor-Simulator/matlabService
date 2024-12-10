package com.babymonitoring.simulationplayer;

import com.mathworks.engine.MatlabEngine;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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

public class Simulation {
    private static int timeIndex = 0;
    private static int simcount = 1;
    private static int prevTimeIndex = 0;
    private static MatlabEngine eng;
    private static Timer timer;
    private static XYSeries series;
    private static CompletableFuture<double[]> simPreResults;
    private static double[] simResults;
    private static boolean endSimulation = false;

    //@Autowired
    public Simulation () {   }
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
    @Async
    public void Chart() {
        try {
            if (GraphicsEnvironment.isHeadless()) {
                System.out.println("Headless environment detected. Cannot display GUI.");
                return;
            }

            int t = 10;
            int steps = 1000;
            double a = 5;
            double f = 0.5;
            double ts = 0;
            double tsp = 0.01;
            double te = 10;

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

            startSimulation(t, steps,a,f,ts,tsp,te);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Async
    public void stopSimulation() {
        timer.stop();
    }

    public static boolean simIsinRange(double y){
        double top =0;
        double bottom =-1;
        return y > bottom && y < top;
    }

    @Async
    public void startSimulation(int t, int steps, double a, double f, double ts, double tsp, double te) throws ExecutionException, InterruptedException {
        simResults = getMatlabResultAsync(a,f,ts,tsp,te).get();
        timer = new Timer(t, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    int xCoord = timeIndex + prevTimeIndex;
                    double yCoord = simResults[timeIndex];

                    series.add(xCoord, yCoord);
                    timeIndex++;

                    if (timeIndex == 2){
                        simPreResults = getMatlabResultAsync(a+simcount, f, ts, tsp, te);
                    }

                    if ((endSimulation || timeIndex >= steps)) {
                        if (simPreResults.isDone() && (simResults[timeIndex-2] < simResults[timeIndex-1]) && simIsinRange(simResults[timeIndex]) ) {
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
}