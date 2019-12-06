package vr20192q1.model;

import java.util.Date;
import java.util.Set;

public class Projeto {
    /**
     * @associates <{vr20192q1.model.Participacao}>
     */
    private Set<Participacao> equipe;

    /**
     * @attribute
     */
    private String nome = null;

    /**
     * @attribute
     */
    private String resumo = null;

    /**
     * @attribute
     */
    private Date inicio = null;

    /**
     * @attribute
     */
    private Date fim = null;


    public Projeto(String nome) {
        this.setNome(nome);
    }


    public void setNome(String nome) {
        this.nome = nome;
    }


    public void setResumo(String resumo) {
        this.resumo = resumo;
    }


    public void setInicio(Date inicio) {
        this.inicio = inicio;
    }

    public void setFim(Date fim) {
        this.fim = fim;
    }

    public String getNome() {
        return nome;
    }

    public String getResumo() {
        return resumo;
    }

    public Date getInicio() {
        return inicio;
    }

    public Date getFim() {
        return fim;
    }


    public Set<Participacao> getEquipe() {
        return equipe;
    }

    public void setEquipe(Set<Participacao> equipe) {
        this.equipe = equipe;
    }


}
