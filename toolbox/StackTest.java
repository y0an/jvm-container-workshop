import java.util.Vector;

public class StackTest {
  private static final int MB = 1024 * 1024;

  public static void main(String[] args) {
    try {
      Thread.sleep(10000);
    } catch (Exception e) {
      //OOPS: handle exception
    }
    
    new One();
  }
  static class One {
    public One () {
      System.out.println("Memory \n\t Free : " + (Runtime.getRuntime().freeMemory() / MB) +
      "\n\t Used : " + (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / MB +
      "\n\t Total : " + (Runtime.getRuntime().totalMemory() / MB));
      new Two();
    }
  }
  static class Two {
    public Two() {
      new One();
      System.out.println("Memory \n\t Free : " + (Runtime.getRuntime().freeMemory() / MB) +
      "\n\t Used : " + (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / MB +
      "\n\t Total : " + (Runtime.getRuntime().totalMemory() / MB));
    }
  }
}


