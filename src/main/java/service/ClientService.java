package service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.Client;
import repository.ClientRepository;

@Service
public class ClientService {
    
    @Autowired
    private ClientRepository clientRepository;
    
    public List<Client> findAll() {
        return clientRepository.findAll();
    }
    
    public Optional<Client> findById(Integer id) {
        return clientRepository.findById(id);
    }
    
    public Client save(Client client) {
        return clientRepository.save(client);
    }
    
    public void deleteById(Integer id) {
        clientRepository.deleteById(id);
    }
    
    public Optional<Client> findByCodeClient(String codeClient) {
        return clientRepository.findByCodeClient(codeClient);
    }
    
    public Optional<Client> findByEmail(String email) {
        return clientRepository.findByEmail(email);
    }
    
    public List<Client> findByNomContainingIgnoreCase(String nom) {
        return clientRepository.findByNomContainingIgnoreCase(nom);
    }
}