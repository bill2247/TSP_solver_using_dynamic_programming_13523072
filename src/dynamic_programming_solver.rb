class DynamicProgrammingSolver
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

    start_time_calc = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    dp = Array.new(1 << @num_nodes) { Array.new(@num_nodes, Float::INFINITY) }
    parent = Array.new(1 << @num_nodes) { Array.new(@num_nodes) }

    dp[1 << @start_node][@start_node] = 0

    (1...(1 << @num_nodes)).each do |mask|
      next unless (mask & (1 << @start_node)) != 0 

      (0...@num_nodes).each do |u|
        next unless (mask & (1 << u)) != 0 

        next if mask == (1 << @start_node) && u == @start_node

        prev_mask_for_u = mask ^ (1 << u) 

        next if prev_mask_for_u == 0 && u != @start_node
        next if (prev_mask_for_u & (1 << @start_node)) == 0 && prev_mask_for_u != 0

        (0...@num_nodes).each do |v|
          if (prev_mask_for_u & (1 << v)) != 0
            cost_v_u = @matrix[v][u]
            if dp[prev_mask_for_u][v] != Float::INFINITY && cost_v_u != Float::INFINITY
              new_cost = dp[prev_mask_for_u][v] + cost_v_u
              if new_cost < dp[mask][u]
                dp[mask][u] = new_cost
                parent[mask][u] = v
              end
            end
          end
        end
      end
    end

    min_total_cost = Float::INFINITY
    last_node_before_returning = -1
    final_mask = (1 << @num_nodes) - 1 

    (0...@num_nodes).each do |i|
      next if i == @start_node && @num_nodes > 1

      cost_i_start = @matrix[i][@start_node]
      if dp[final_mask][i] != Float::INFINITY && cost_i_start != Float::INFINITY
        current_total_cost = dp[final_mask][i] + cost_i_start
        if current_total_cost < min_total_cost
          min_total_cost = current_total_cost
          last_node_before_returning = i
        end
      end
    end

    optimal_paths_nodes = []
    if min_total_cost == Float::INFINITY
    else
      current_path = []
      curr_node = last_node_before_returning
      temp_mask = final_mask

      while curr_node != @start_node && !curr_node.nil?
        current_path.unshift(curr_node)
        prev_node = parent[temp_mask][curr_node]
        temp_mask ^= (1 << curr_node)
        curr_node = prev_node
        break if curr_node.nil? && temp_mask != (1 << @start_node) 
      end
      current_path.unshift(@start_node)
      current_path.push(@start_node)
      optimal_paths_nodes << current_path
    end

    end_time_calc = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    execution_time = end_time_calc - start_time_calc

    if optimal_paths_nodes.empty? && @num_nodes > 0
        min_total_cost = Float::INFINITY
    end

    { paths: optimal_paths_nodes, cost: min_total_cost, time: execution_time }
  end
end