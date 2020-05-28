############################################################
#  Name:                Jon Czerniak
#  Assignment:          Puzzle Class: the nuts and bolts of word puzzles
#  Date:                06/9/2019
#  Class:               CIS 283
#  Description:         the puzzle class to create the most difficult word search puzzle IN THE WORLD!!!
############################################################

class Puzzle

  attr_accessor :word_array, :end_col, :end_row, :directions, :letter_array, :word_accepted
  attr_reader :letter_list, :word_column
  attr_writer :text_file

  def initialize(text_file)
    @text_file = text_file
    @directions = []
    @word_list = []
    @letter_list = []
    @word_column = ""
    @puz = []
    45.times do
      @puz << ("." * 45).split("")
    end
  end

  #change to to_s
  def print_puz
    ret_str = ""
    @puz.each do |row|
      ret_str += row.join(" ") + "\n"
    end

    return ret_str
  end

  def select_start_column
    start_column = rand (0..44)
    return start_column
  end

  def select_start_row
    start_row = rand(0..44)
    return start_row
  end


  def select_direction
    direction_num = rand(1..8)

    case direction_num #[col N/S, row E/W]
    when 1
      direction = [1, 0, "N"]
    when 2
      direction = [1, 1, "NE"]
    when 3
      direction = [0, 1, "E"]
    when 4
      direction = [-1, 1, "SE"]
    when 5
      direction = [-1, 0, "S"]
    when 6
      direction = [-1, -1, "SW"]
    when 7
      direction = [0, -1, "W"]
    when 8
      direction = [1, -1, "NW"]

    end

    return direction

  end

  def import_word_file()
    word_file = File.open(@text_file, "r")
    word_file_index = 0
    while !word_file.eof
      @word_list << word_file.gets.chomp.to_s.upcase
      @word_column += @word_list[word_file_index].to_s + ","
      word_file_index += 1
    end

    #sort by number of letters
    @word_list.sort_by! {|word| word.length}

  end

  #------

  def OOB_check(starting_col, starting_row, direction, number_of_letters)
    col_out_of_bounds = true
    row_out_of_bounds = true
    vertical_direction = direction[0]
    horizontal_direction = direction[1]

    until col_out_of_bounds == false
      chars_to_move = number_of_letters * vertical_direction
      @end_col = starting_col + (chars_to_move)


      if @end_col > 45 || @end_col < 0
        direction[0] *= (-1)
        vertical_direction = direction[0]
        chars_to_move = 0
      else
        col_out_of_bounds = false
      end
    end


    until row_out_of_bounds == false
      chars_to_move = number_of_letters * horizontal_direction
      @end_row = starting_row + (chars_to_move)

      if @end_row > 45 || @end_row < 0
        direction[1] *= (-1)
        horizontal_direction = direction[1]
        chars_to_move = 0
      else
        row_out_of_bounds = false
      end
    end
  end

  #---------
  def check_letters(word_array, start_col, start_row)
    letter_index = 0
    accept_word = false
    #check for "." or for a matching letter
    word_array.each do |letter|
      if @puz[start_col][start_row] == "." || @puz[start_col][start_row] == letter
        letter_index += 1
        start_col += @directions[0]
        start_row += @directions[1]
      else
        letter_index = word_array.length + 1
      end

      #check the value of word_array to see if the word woas accepted
      if letter_index == word_array.length
        accept_word = true
      elsif letter_index > word_array.length
        accept_word = false
      end
    end

    return accept_word

  end

  #---------

  def place_words
    import_word_file()
    word_list_index = 0
    word_list_size = @word_list.length
    @word_accepted = false

    while word_list_index < word_list_size
      word = @word_list.pop
      #next until loop goes here
      until @word_accepted == true


        # place word into it's own array
        letter_index = 0
        @word_array = []

        while letter_index < word.length
          @word_array << word[letter_index]
          letter_index += 1
          #populate the letter array for later use
          if @letter_list.include?(word[letter_index]) == false && word[letter_index] != nil && word[letter_index] != " "
            @letter_list << word[letter_index]
          end
        end


        #get the start location
        start_col = select_start_column
        start_row = select_start_row
        @directions = select_direction

        #check for column out of bounds
        OOB_check(start_col, start_row, @directions, @word_array.length)

        # check letters for matching letter of "."
        @word_accepted = check_letters(@word_array, start_col, start_row)
      end

      @word_array.each do |letter|

        @puz[start_col][start_row] = letter
        start_col += @directions[0]
        start_row += @directions[1]

      end

      word_list_index += 1
      @word_accepted = false

    end #end while word_index <
  end

  #end place_word method

  def fill_blanks()
    #get row
    row_index = 0
    while row_index < @puz.length

      col_index = 0
      #get column in each row
      while col_index < @puz[row_index].length
        if @puz[row_index][col_index] == "." || @puz[row_index][col_index] == " "
          cell_value = (rand(0..@letter_list.length) - 1)
          @puz[row_index][col_index] = @letter_list[cell_value]
          col_index += 1
        else
          col_index += 1
        end
      end
      row_index += 1
    end
    return @puz
  end

  def print_word_list
    word_column = ""
    @word_list.each do |word|
      word_column += "#{word}\n"
    end
    return word_column
  end

  #end class
end



