package com.oilfield.petition.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class HomeController {

    @GetMapping("/home")
    public Map<String, Object> home() {
        return Map.of(
            "title", "油田信访系统",

            "description", "欢迎使用油田信访系统"
        );
    }
}
