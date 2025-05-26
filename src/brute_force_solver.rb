class BruteForceSolver
  attr_reader :matrix, :num_nodes, :start_node

  def initialize(matrix, start_node = 0)
    @matrix = matrix
    @num_nodes = matrix.length
    @start_node = start_node
  end

  def solve
    if @num_nodes == 0
      return { paths: [], cost: 0, time: 0.0 }
    elsif @num_nodes == 1
      cost = @matrix[@start_node][@start_node] || 0
      return { paths: [[[@start_node, @start_node]]], cost: cost, time: 0.0 }
    end

    nodes_to_permute = (0...@num_nodes).to_a - [@start_node]
    min_cost = Float::INFINITY
    optimal_paths_nodes = []

    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    nodes_to_permute.permutation.each do |permuted_nodes|
      current_path_nodes = [@start_node] + permuted_nodes + [@start_node]
      current_cost = 0
      valid_path = true

      (0...current_path_nodes.length - 1).each do |i|
        u = current_path_nodes[i]
        v = current_path_nodes[i+1]

        if @matrix[u].nil? || @matrix[u][v].nil? || @matrix[u][v] == Float::INFINITY
          valid_path = false
          break
        end
        current_cost += @matrix[u][v]
      end

      next unless valid_path

      if current_cost < min_cost
        min_cost = current_cost
        optimal_paths_nodes = [current_path_nodes]
      elsif current_cost == min_cost
        optimal_paths_nodes << current_path_nodes
      end
    end

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    execution_time = end_time - start_time

    if optimal_paths_nodes.empty? && @num_nodes > 0 
        min_cost = Float::INFINITY
    end

    { paths: optimal_paths_nodes, cost: min_cost, time: execution_time }
  end
end