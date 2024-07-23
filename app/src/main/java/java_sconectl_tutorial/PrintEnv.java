package java_sconectl_tutorial;


import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController("/")
public class PrintEnv{
    
    @GetMapping
    public void printEnv() throws NoSuchAlgorithmException, UnsupportedEncodingException, InterruptedException{
        String user = System.getenv("API_USER");
        String pw = System.getenv("API_PASSWORD");

        if (user == null || pw == null){
            System.out.println("Not all required environment variables are defined");
            System.exit(1);
        }

        System.out.println("Hello, " + user + " - thanks for passing along the API_PASSWORD");

        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] pwChecksum = md.digest(pw.getBytes("UTF-8"));
        System.out.println("The checksum of the original API_PASSWORD is '" + new BigInteger(1, pwChecksum).toString(16) + "'");

        while(true) {
            String newUser = System.getenv("API_USER");
            System.out.println("Hello, user " + newUser);

            if (!newUser.equals(user)) {
                System.out.println("Integrity violation: The value of API_USER changed from "+user+" to "+newUser+"!");
                System.exit(1);
            }

            String newPw = System.getenv("API_PASSWORD");
            byte[] newPwChecksum = null;
            if (newPw != null) 
                newPwChecksum = md.digest(newPw.getBytes("UTF-8"));
            System.out.println("The checksum of the current password is '" + new BigInteger(1, newPwChecksum).toString(16) + "'");
            
            if (!Arrays.equals(newPwChecksum, pwChecksum)) {
                System.out.println("Integrity violation: The checksum of API_PASSWORD changed from '" + new BigInteger(1, pwChecksum).toString(16) + " to " + new BigInteger(1, newPwChecksum).toString(16) + "!");
                System.exit(1);
            }

            System.out.println("Stop me by executing 'helm uninstall javaapp'");
            Thread.sleep(10 * 1000);
        }
    }
}