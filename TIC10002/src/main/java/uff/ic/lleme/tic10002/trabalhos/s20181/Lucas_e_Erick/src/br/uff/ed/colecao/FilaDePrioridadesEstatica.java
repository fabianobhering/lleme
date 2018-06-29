package br.uff.ed.colecao;

import java.io.Serializable;

import br.uff.ed.main.Cliente;

@SuppressWarnings("rawtypes")
public class FilaDePrioridadesEstatica<T extends Comparable> extends FilaDePrioridadesAbstrata<T>
		implements Serializable {

	private static final long serialVersionUID = 7454597459073987175L;

	public FilaDePrioridadesEstatica(int tamanhodafila) {
		super(tamanhodafila);
	}

	/*
	 * esta fila assume que as prioridades são estáticas, ou seja, ao entrar na fila
	 * o elemento já tem sua prioridade definida e as prioridades dos demais
	 * elementos não é alterada. Dessa forma, o custo de inserir um novo elemento
	 * depende da função subir que tem custo O(log n).
	 */
	public void add(T t) {
		if (this.qtdElementosNNulos >= this.heapMAX.length) {
			aumentaHEAP();
		}
		this.heapMAX[qtdElementosNNulos + 1] = t;
		qtdElementosNNulos++;
		System.out.println(qtdElementosNNulos);
		subir(qtdElementosNNulos);
		System.out.println(((Cliente) this.heapMAX[1]).getNome());
	}

}
