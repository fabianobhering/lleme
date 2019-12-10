package vr20192q1;

import vr20192q1.model.Participacao;
import vr20192q1.model.Projeto;


public abstract class Main {
    public static void main(String[] args) {
        Projeto[] projetos;
        for (Projeto p : projetos) {
            for (Participacao r : p.getEquipe()) {
                System.out.println(p.getNome() + "," + r.getFuncionario().getNome() + "'" + r.getInicio().toString() +
                                   "," + r.getFim().toString());
            }
        }
    }
}
