package uff.ic.lleme.tcc00328.aulas.concurrency.simpleThreads;

class MessageLoop implements Runnable {

    // Display a message, preceded by the name of the current thread
    public static void threadMessage(String message) {
        String threadName = Thread.currentThread().getName();
        System.out.format("%s: %s%n", threadName, message);
    }

    public void run() {
        String[] importantInfo = {"Mares eat oats", "Does eat oats", "Little lambs eat ivy", "A kid will eat ivy too"};
        if (!Thread.interrupted())
            try {
            for (int i = 0; i < importantInfo.length; i++) {
                Thread.sleep(4000);
                // Print a message
                threadMessage(importantInfo[i]);
            }
        } catch (InterruptedException e) {
            SimpleThreads.threadMessage("I wasn't done!");
        }
    }

}
