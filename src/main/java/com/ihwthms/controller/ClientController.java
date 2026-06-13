package com.ihwthms.controller;

import com.ihwthms.entity.ClientEntity;
import com.ihwthms.entity.User;
import com.ihwthms.model.ClientDTO;
import com.ihwthms.repository.UserRepository;
import com.ihwthms.service.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
public class ClientController {

    @Autowired private ClientService clientService;
    @Autowired private UserRepository userRepository;

    private static final List<String> CLIENT_STATUSES = Arrays.asList(
            "Active", "Inactive", "Prospect", "Blacklisted");

    private User getLoggedInUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username).orElse(null);
    }

    // ─── ADD CLIENT FORM ─────────────────────────────────────────────────────
    @GetMapping("view_add_client_form")
    public ModelAndView viewAddClientForm() {
        ModelAndView mv = new ModelAndView("admin/client/Admin_Add_Client");
        mv.addObject("CLIENT_OBJ", new ClientDTO());
        mv.addObject("CLIENT_STATUSES", CLIENT_STATUSES);
        return mv;
    }

    // ─── CREATE CLIENT ───────────────────────────────────────────────────────
    @PostMapping("create_client")
    public String createClient(@ModelAttribute("CLIENT_OBJ") ClientDTO dto,
                               RedirectAttributes ra) {
        if (dto.getMobile() != null && !dto.getMobile().trim().isEmpty()
                && clientService.isMobileExists(dto.getMobile())) {
            ra.addFlashAttribute("error", "A client with this mobile number already exists.");
            return "redirect:view_add_client_form";
        }

        User loggedIn = getLoggedInUser();
        ClientEntity entity = buildEntityFromDTO(dto, null, loggedIn);
        clientService.saveClient(entity);
        ra.addFlashAttribute("success", "Client created successfully!");
        return "redirect:view_clients_list";
    }

    // ─── CLIENT LIST ─────────────────────────────────────────────────────────
    @GetMapping("view_clients_list")
    public ModelAndView viewClientList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String clientName,
            @RequestParam(required = false) Boolean active,
            @RequestParam(required = false) String city) {

        ModelAndView mv = new ModelAndView("admin/client/viewClientListing");
        Page<ClientEntity> paged = clientService.filterClients(clientName, active, city,
                PageRequest.of(page, pageSize));

        List<ClientDTO> dtoList = new ArrayList<>();
        for (ClientEntity e : paged.getContent()) {
            dtoList.add(new ClientDTO(e));
        }

        mv.addObject("CLIENT_LIST", dtoList);
        mv.addObject("currentPage", page);
        mv.addObject("totalPages", paged.getTotalPages());
        mv.addObject("totalClients", paged.getTotalElements());
        mv.addObject("pageSize", pageSize);
        mv.addObject("f_clientName", clientName);
        mv.addObject("f_active", active);
        mv.addObject("f_city", city);
        mv.addObject("CLIENT_STATUSES", CLIENT_STATUSES);
        return mv;
    }

    // ─── VIEW CLIENT DETAILS ─────────────────────────────────────────────────
    @GetMapping("view_client_details")
    public ModelAndView viewClientDetails(@RequestParam Long clientId) {
        ModelAndView mv = new ModelAndView("admin/client/Admin_View_Client");
        ClientEntity entity = clientService.findById(clientId);
        mv.addObject("CLIENT_OBJ", new ClientDTO(entity));
        return mv;
    }

    // ─── EDIT CLIENT FORM ────────────────────────────────────────────────────
    @GetMapping("view_edit_client_form")
    public ModelAndView viewEditClientForm(@RequestParam Long clientId) {
        ModelAndView mv = new ModelAndView("admin/client/Admin_Edit_Client");
        ClientEntity entity = clientService.findById(clientId);
        mv.addObject("CLIENT_OBJ", new ClientDTO(entity));
        mv.addObject("CLIENT_STATUSES", CLIENT_STATUSES);
        return mv;
    }

    // ─── UPDATE CLIENT ───────────────────────────────────────────────────────
    @PostMapping("edit_client")
    public String editClient(@ModelAttribute("CLIENT_OBJ") ClientDTO dto,
                             RedirectAttributes ra) {
        if (dto.getMobile() != null && !dto.getMobile().trim().isEmpty()
                && clientService.isMobileExistsForOther(dto.getMobile(), dto.getClientId())) {
            ra.addFlashAttribute("error", "Another client already uses this mobile number.");
            return "redirect:view_edit_client_form?clientId=" + dto.getClientId();
        }
        User loggedIn = getLoggedInUser();
        ClientEntity existing = clientService.findById(dto.getClientId());
        buildEntityFromDTO(dto, existing, loggedIn);
        clientService.saveClient(existing);
        ra.addFlashAttribute("success", "Client updated successfully!");
        return "redirect:view_clients_list";
    }

    // ─── TOGGLE ACTIVE ───────────────────────────────────────────────────────
    @PostMapping("toggle_client")
    public String toggleClient(@RequestParam Long clientId, RedirectAttributes ra) {
        clientService.toggleActive(clientId);
        ra.addFlashAttribute("success", "Client status updated.");
        return "redirect:view_clients_list";
    }

    // ─── Helper ──────────────────────────────────────────────────────────────
    private ClientEntity buildEntityFromDTO(ClientDTO dto, ClientEntity existing, User loggedIn) {
        ClientEntity entity = existing != null ? existing : new ClientEntity();
        entity.setClientName(dto.getClientName());
        entity.setMobile(dto.getMobile());
        entity.setEmailId(dto.getEmailId());
        entity.setCity(dto.getCity());
        entity.setCountry(dto.getCountry());
        entity.setClientStatus(dto.getClientStatus() != null ? dto.getClientStatus() : "Active");
        entity.setRemarks(dto.getRemarks());
        entity.setActive(dto.getActive() != null ? dto.getActive() : Boolean.TRUE);
        if (loggedIn != null) {
            if (existing == null) entity.setCreatedBy(loggedIn.getId());
            entity.setUpdatedBy(loggedIn.getId());
        }
        return entity;
    }
}
