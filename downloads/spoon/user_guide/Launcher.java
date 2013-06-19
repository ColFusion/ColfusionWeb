import java.awt.Desktop;
import java.io.File;
import java.io.IOException;


public class Launcher {

    public static void openFile(File document) throws IOException {
        Desktop dt = Desktop.getDesktop();
        dt.open(document);
    }
    
    public static void main(String[] args) {

    	File user_guide = new File("index.html");
    	
    	Desktop dt = Desktop.getDesktop();
        try {
			dt.open(user_guide);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
	
}
