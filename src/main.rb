require_relative 'matrix_reader'
require_relative 'brute_force_solver'
require_relative 'dynamic_programming_solver'
require_relative 'output_formatter'

def run_tsp_solver
  puts "Masukkan path ke file matriks ketetanggaan (misalnya, matrix.txt):"
  file_path = gets.chomp
  file_path = "test/" + file_path 

  begin
    adj_matrix = MatrixReader.read(file_path)
  rescue StandardError => e
    puts e.message
    return
  end

  num_nodes = adj_matrix.length

  if num_nodes == 0 
    puts "Matriks kosong, tidak ada yang bisa diproses."
    return
  end

  OutputFormatter.print_matrix(adj_matrix)

  brute_force_results = {}
  if num_nodes <= 10
    puts "\nMenjalankan Solusi Brute Force..."
    bf_solver = BruteForceSolver.new(adj_matrix)
    brute_force_results = bf_solver.solve
    puts "Solusi Brute Force Selesai."
  else
    puts "\nJumlah node (#{num_nodes}) terlalu besar untuk Brute Force (disarankan <= 10)."
    brute_force_results = {
      time: "N/A (dilewati, >10 node)",
      cost: "N/A",
      paths: []
    }
  end
  OutputFormatter.print_solution_results("Brute Force", brute_force_results)

  puts "\nMenjalankan Solusi Dynamic Programming (Held-Karp)..."
  dp_solver = DynamicProgrammingSolver.new(adj_matrix)
  dp_results = dp_solver.solve
  puts "Solusi Dynamic Programming Selesai."
  OutputFormatter.print_solution_results("Dynamic Programming", dp_results)

  puts "\n" + "="*40 + "\n"
end

if __FILE__ == $PROGRAM_NAME
  run_tsp_solver
end