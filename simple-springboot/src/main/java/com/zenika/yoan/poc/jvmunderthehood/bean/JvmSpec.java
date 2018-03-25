package com.zenika.yoan.poc.jvmunderthehood.bean;

/**
 * Created by y0an on 23/01/18.
 */
public class JvmSpec {


    String core;
    String used,free,available,max;

    public JvmSpec() {

        int mb = 1024*1024;

        Runtime runtime = Runtime.getRuntime();

        core = runtime.availableProcessors() + " Cores";
        used = ((runtime.totalMemory() - runtime.freeMemory()) / mb) + " Mem Used";
        free = (runtime.freeMemory() / mb) + " Free Mem";
        available = (runtime.totalMemory() / mb) + " Available Mem";
        max = (runtime.maxMemory() / mb) + " Max Mem";
    }

    public String getCore() {
        return core;
    }

    public String getUsed() {
        return used;
    }

    public String getFree() {
        return free;
    }

    public String getAvailable() {
        return available;
    }

    public String getMax() {
        return max;
    }
}
