package com.oilfield.petition.controller;

import com.oilfield.petition.entity.Petition;
import com.oilfield.petition.repository.PetitionRepository;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/petitions")
public class PetitionController {

    private final PetitionRepository petitionRepository;

    public PetitionController(PetitionRepository petitionRepository) {
        this.petitionRepository = petitionRepository;
    }

    @PostMapping
    public Map<String, Object> create(@RequestBody Petition petition) {
        petition.setPetitionCode(generateCode());
        petition.setStatus("已登记");
        petition.setRegisterTime(LocalDateTime.now());
        petition.setIsDel(0);
        petition.setIsDuplicate(0);
        petition.setIsOvertime(0);
        petition.setDeadlineDate(LocalDateTime.now().plusDays(60));
        if (petition.getIsCollective() == null) {
            petition.setIsCollective(0);
        }

        petitionRepository.save(petition);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("message", "信访登记成功");
        result.put("petitionCode", petition.getPetitionCode());
        return result;
    }

    @GetMapping("/categories")
    public Map<String, Object> categories() {
        Map<String, List<String>> data = new LinkedHashMap<>();
        data.put("劳动保障", List.of("劳动合同", "社会保险", "工伤待遇", "劳动时间", "休息休假"));
        data.put("薪酬福利", List.of("工资发放", "奖金津贴", "福利待遇", "公积金"));
        data.put("安全生产", List.of("作业环境", "安全防护", "职业健康", "事故处理"));
        data.put("环境保护", List.of("污染防治", "生态修复", "环境监测", "环评公示"));
        data.put("人事管理", List.of("岗位调动", "职务晋升", "绩效考核", "教育培训", "退休安置"));
        data.put("生活服务", List.of("住房保障", "子女教育", "医疗服务", "食堂餐饮", "通勤交通"));
        data.put("其他", List.of("其他诉求"));

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("data", data);
        return result;
    }

    private String generateCode() {
        String today = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        Petition last = petitionRepository.findTopByOrderByIdDesc();
        int seq = 1;
        if (last != null && last.getPetitionCode() != null && last.getPetitionCode().startsWith("XF" + today)) {
            try {
                seq = Integer.parseInt(last.getPetitionCode().substring(10)) + 1;
            } catch (NumberFormatException ignored) {}
        }
        return "XF" + today + String.format("%04d", seq);
    }
}
