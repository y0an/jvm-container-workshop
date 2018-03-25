package com.zenika.yoan.poc.jvmunderthehood.controller;

import java.util.Vector;

import com.zenika.yoan.poc.jvmunderthehood.bean.JvmSpec;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by y0an on 23/01/18.
 */
@RestController
@RequestMapping("/jvm")
public class JvmSpecController {

  private static final int MB = 1024 * 1024;

  @Autowired
  private JvmSpec jvmSpec;

  @RequestMapping(value = "/spec", method = RequestMethod.GET)
  public ResponseEntity<JvmSpec> spec() {
    return new ResponseEntity<>(jvmSpec, HttpStatus.FOUND);
  }


  @RequestMapping(value = "/heap", method = RequestMethod.GET)
  public void heap() {
    
    System.out.println("available processors: " + Runtime.getRuntime().availableProcessors());
    System.out.println("max memory: " + (Runtime.getRuntime().maxMemory() / MB));
    System.out.println("total memory: " + (Runtime.getRuntime().totalMemory() / MB));

    Vector v = new Vector();
    while (true) {
      byte b[] = new byte[MB];
      v.add(b);
      System.out.println("free memory: " + (Runtime.getRuntime().freeMemory() / MB));
    }
      
  }

  @Bean
  public JvmSpec jvmSpec() {
    return new JvmSpec();
  }
}
