public class ListaAssuntos {
	int 	qtdAssuntos;
	Assunto primeiroAssunto;
	Assunto ultimoAssunto;
	
	//inicializando a lista de assuntos vazia
	public ListaAssuntos() {
		this.qtdAssuntos		=	0;
		this.primeiroAssunto	= null;
		this.ultimoAssunto		= null;
	}
	/*Inserir no final = fila*/
	public void insere(ListaAssuntos lista, Assunto novo) {
		if (lista.qtdAssuntos == 0) {
			//novo.setProximoAssunto(ultimoAssunto);
			lista.primeiroAssunto 	= novo;
			lista.ultimoAssunto		= novo;
			
		}else {
			lista.ultimoAssunto.setProximoAssunto(novo);
			lista.ultimoAssunto = novo;
			
		}
		
		this.qtdAssuntos++;	
	}
	
	public void imprimeListaAssuntos() {
		if (this.qtdAssuntos == 0) {
			System.out.println("A lista está vazia!");
		}else {
			Assunto aux = primeiroAssunto;
			System.out.println(qtdAssuntos);
			for (int i = 0; i < this.qtdAssuntos; i++) {
				System.out.println("Urgência: "+aux.getTipoAssunto().urgencia+ " / Tipo do assunto: "+ aux.getTipoAssunto().titulo+" / Descrição: "+ aux.getDescricao() + " / Providencia: "+
			aux.getProvidencia() + " / Duração Atendimento: "+aux.getDuracaoAtendimentoAssunto() + " Contador: "+aux.getCont());
				aux = aux.proximoAssunto;
			}
		}
	}
	
	


}