class MatrixReader
  def self.read(file_path)
    matrix = []
    begin
      File.open(file_path, 'r') do |file|
        file.each_line do |line|
          row = line.strip.split(/\s+/).map(&:to_i)
          matrix << row
        end
      end
    rescue Errno::ENOENT
      raise "Error: File tidak ditemukan di path '#{file_path}'"
    rescue StandardError => e
      raise "Error saat membaca file: #{e.message}"
    end
    validate_matrix(matrix)
    matrix
  end

  private

  def self.validate_matrix(matrix)
    if matrix.empty?
      raise "Error: Matriks kosong."
    end

    num_rows = matrix.length
    num_cols_first_row = matrix[0].length

    if num_cols_first_row == 0 && num_rows > 0
      raise "Error: Baris pertama matriks kosong padahal ada baris."
    end

    matrix.each_with_index do |row, i|
      if row.length != num_cols_first_row
        raise "Error: Matriks tidak seragam. Baris #{i + 1} memiliki #{row.length} elemen, diharapkan #{num_cols_first_row}."
      end
    end

    if num_rows != num_cols_first_row
      raise "Error: Matriks tidak persegi. Jumlah baris (#{num_rows}) tidak sama dengan jumlah kolom (#{num_cols_first_row})."
    end
  end
end
