import java.util.Vector;

public class ThreadTest {
  private static final int MB = 1024 * 1024;
  public static void main(String[] args) {
    Vector v = new Vector();
    int i=0;
    while (true) {
      Thread t = new Thread();
      v.add(t);
      i++;
      System.out.println("Thread: "+ i);
      System.out.println("Memory \n\t Free : " + (Runtime.getRuntime().freeMemory() / MB) +
      "\n\t Used : " + (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / MB +
      "\n\t Total : " + (Runtime.getRuntime().totalMemory() / MB) 
      );
    }
  }
}
