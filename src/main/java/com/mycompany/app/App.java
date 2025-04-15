package com.mycompany.app;
import java.lang.Exception;
import io.sentry.Sentry;


public class App {
    static {
        Sentry.init(options -> {
            options.setDsn("https://4fc257ea33576ddb8b923eff319ee062@o4509091708928000.ingest.us.sentry.io/4509154601074688");
            options.setDebug(true);
            options.setSendDefaultPii(true);
            options.setRelease("my-app@1.2.3");
        });
    }

    public static void main(String[] args) {
        try {
            throw new Exception("This is exception");
        } catch (Exception e) {
            try {
                Sentry.captureException(e);
                Thread.sleep(1000);
            } catch (InterruptedException ie) {
                // Ignore
            }
        }
    }
}

