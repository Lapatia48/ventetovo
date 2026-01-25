package service;

import entity.Role;
import org.springframework.stereotype.Service;
import repository.RoleRepo;

@Service
public class RoleServicee {

    private final RoleRepo roleRepo;

    public RoleServicee(RoleRepo roleRepo) {
        this.roleRepo = roleRepo;
    }

    public Role getRoleById(Integer idRole) {
        return roleRepo.findById(idRole).orElse(null);
    }
}
