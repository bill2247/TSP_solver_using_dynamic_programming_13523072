module OutputFormatter
  def self.print_matrix(matrix)
    puts "\nMatriks Ketetanggaan (dimensi #{matrix.length}x#{matrix.length}):"
    matrix.each { |row| puts row.join("\t") }
  end

  def self.print_solution_results(solver_name, results)
    puts "\n" + "="*10 + " #{solver_name} " + "="*10
    if results[:time].is_a?(String) 
        puts "Waktu Eksekusi: #{results[:time]}"
        puts "Total Bobot Path Minimum: #{results[:cost]}"
        puts "Path yang ditemukan: (dilewati)"
    else
        puts "Waktu Eksekusi: #{format_time(results[:time])} detik"
        if results[:cost] == Float::INFINITY || results[:paths].empty?
          puts "Tidak ditemukan path solusi."
        else
          puts "Total Bobot Path Minimum: #{results[:cost]}"
          puts "Path yang ditemukan (#{results[:paths].length}):"
          results[:paths].each_with_index do |path, index|
            puts "  #{index + 1}. #{path.map(&:to_s).join(' -> ')}"
          end
        end
    end
  end

  def self.format_time(seconds)
    format("%.6f", seconds)
  end
end