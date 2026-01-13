package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import service.ArticleService;

@Controller
public class AchatController {

	@Autowired
	private ArticleService articleService;

	@GetMapping("/achat/achat")
	public String achat(Model model) {
		model.addAttribute("articles", articleService.findAll());
        model.addAttribute("bob", "bob");
		return "achat/achat";
	}


    @GetMapping("/achat/quantite")
    public String commande(@RequestParam("idArticle") Integer idArticle, Model model) {
        model.addAttribute("idArticle", idArticle);
        return "achat/quantite";
    }

    @PostMapping("/achat/quantite")
    public String quantite(@RequestParam("idArticle") Integer idArticle, 
                            @RequestParam("quantite") Integer quantite,
                            Model model) {
        return "achat/quantite";
    }

}