package vr20192q1.model;

import java.util.Set;


public class Funcionario {
    /**
     * @associates <{vr20192q1.model.Participacao}>
     */
    private Set<Participacao> colaboracoes;

    /**
     * @attribute
     */
    private String nome = null;


    public Funcionario(String nome) {
        this.setNome(nome);
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Set<Participacao> getColaboracoes() {
        return colaboracoes;
    }

    public void setColaboracoes(Set<Participacao> colaboracoes) {
        this.colaboracoes = colaboracoes;
    }
}

