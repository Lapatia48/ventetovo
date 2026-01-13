package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import entity.Article;
import repository.ArticleRepository;
import java.util.List;
import java.util.Optional;

@Service
public class ArticleService {
    
    @Autowired
    private ArticleRepository articleRepository;
    
    public List<Article> findAll() {
        return articleRepository.findAll();
    }
    
    public Optional<Article> findById(Integer id) {
        return articleRepository.findById(id);
    }
    
    public Optional<Article> findByCode(String code) {
        return articleRepository.findByCode(code);
    }
    
    public Article save(Article article) {
        return articleRepository.save(article);
    }
    
    public void delete(Integer id) {
        articleRepository.deleteById(id);
    }
}