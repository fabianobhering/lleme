package br.uff.ed.colecao;

import java.io.Serializable;

import br.uff.ed.main.Cliente;
import br.uff.ed.main.Priorizavel;

@SuppressWarnings("rawtypes")
public class FilaDePrioridadesDinamica<T extends Comparable & Priorizavel> extends FilaDePrioridadesAbstrata<T>
		implements Serializable {

	private static final long serialVersionUID = -2834229347761719146L;

	public FilaDePrioridadesDinamica(int tamanhodafila) {
		super(tamanhodafila);
	}

	/*
	 * por necessitar percorrer todo o heap e atualizar todos os elementos, a
	 * complexidade de inserir um novo elemento é On + o custo do subir que é O(log
	 * n), ou seja, o custo total será On por ser o termo mais relevante.
	 */
	@SuppressWarnings("unchecked")
	public void add(T t) {
		System.out.println("a hora de entrada foi: " + t.getPriorizador());
		System.out.println("a prioridade do novo nó foi: " + ((Cliente) t).getPrioridade());
		if (qtdElementosNNulos != 0) {
			for (int i = 1; i <= qtdElementosNNulos; i++) {
				((T) this.heapMAX[i]).priorizar(t.getPriorizador());
				System.out.println("a prioridade do cliente " + ((Cliente) this.heapMAX[i]).getNome() + " é: "
						+ ((Cliente) this.heapMAX[i]).getPrioridade());
			}
		}
		if (qtdElementosNNulos >= this.heapMAX.length) {
			aumentaHEAP();
		}
		this.heapMAX[qtdElementosNNulos + 1] = t;
		qtdElementosNNulos++;
		subir(qtdElementosNNulos);
		System.out.println("o novo topo é: " + (((Cliente) this.heapMAX[1]).getNome()));
	}

}
