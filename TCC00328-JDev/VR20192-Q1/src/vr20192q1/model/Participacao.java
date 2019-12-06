package vr20192q1.model;

import java.util.Date;


public class Participacao {


    private Projeto projeto;
    private Funcionario funcionario;

    /**
     * @attribute
     */
    private Date inicio;

    /**
     * @attribute
     */
    private Date fim;

    public Participacao() {

    }

    public Projeto getProjeto() {
        return projeto;
    }

    public void setProjeto(Projeto projeto) {
        this.projeto = projeto;
    }

    public Funcionario getFuncionario() {
        return funcionario;
    }

    public void setFuncionario(Funcionario funcionario) {
        this.funcionario = funcionario;
    }

    public Date getInicio() {
        return inicio;
    }

    public void setInicio(Date inicio) {
        this.inicio = inicio;
    }

    public Date getFim() {
        return fim;
    }

    public void setFim(Date fim) {
        this.fim = fim;
    }


}
