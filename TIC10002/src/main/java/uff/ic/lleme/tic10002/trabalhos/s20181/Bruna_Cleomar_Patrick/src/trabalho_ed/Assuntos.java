package trabalho_ed;



/*  A classe Assuntos representa uma coleção de Assuntos tratados durante um Atendimento a um Cliente
 *  Herda de ListaEstatica.
 *  Optamos por uma Lista Estatica pois durante um atendimento cada Assunto precisa ser acessado de forma linear para ter a providência
 *  e a duração do atendimento informados.
 *  */

public class Assuntos extends ListaEstatica {
	private int sumUrgencias;
	public Assuntos(int tamanho) {
		super(tamanho);
		// TODO Auto-generated constructor stub
	}
	
	@Override
    public boolean Inserir(Object e) {
        if (this.getTamanho() + 1 <= tamanho) {
        	Assunto ass = (Assunto)e;
        	this.sumUrgencias += ass.getTipoAssunto().getUrgencia();
            ((Object[]) this.lista)[indice++] = e;
            return true;
        }
        return false;
    }

    public int getUrgenciaMedia() {
    	return this.sumUrgencias/(indice + 1);
    }
}

