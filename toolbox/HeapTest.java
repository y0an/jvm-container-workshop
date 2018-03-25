import java.util.Vector;

public class HeapTest {
  private static final int MB = 1024 * 1024;
  public static void main(String[] args) {

    System.out.println("available processors: " + Runtime.getRuntime().availableProcessors());
    System.out.println("max memory: " + (Runtime.getRuntime().maxMemory() / MB));
    System.out.println("total memory: " + (Runtime.getRuntime().totalMemory() / MB));
    try {
      Thread.sleep(10000);
    } catch (Exception e) {
      //OOPS: handle exception
    }
    Vector v = new Vector();
    while (true) {
      byte b[] = new byte[MB];
      v.add(b);
      System.out.println("Memory \n\t Free : " + (Runtime.getRuntime().freeMemory() / MB) +
                                "\n\t Used : " + (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / MB +
                                "\n\t Total : " + (Runtime.getRuntime().totalMemory() / MB) 
                                );
    }
  }
}
