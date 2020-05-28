############################################################
#  Name:                Jon Czerniak
#  Assignment:          Word Puzzle creation
#  Date:                06/9/2019
#  Class:               CIS 283
#  Description:         calls the puzzle class to create word search puzzle
############################################################

require 'prawn'
require_relative 'puzzle'

start = Time.now

x = Puzzle.new('words.txt')
x.place_words
answer_key = x.print_puz
search_words = x.word_column

x.fill_blanks
word_puzzle = x.print_puz


Prawn::Document.generate("Cz_word_puzzle.pdf") do |pdf|


  pdf.font "Courier"
  pdf.text "Answer Key", :align => :center, :size => 18

  pdf.move_down 12
  pdf.text "#{answer_key}", :align => :center, :size => 10

  pdf.move_down 9
  pdf.column_box([50, pdf.cursor], :columns => 3, :width => pdf.bounds.width) do
    pdf.text(<<-END.gsub(/,/, "\n"))
      #{search_words}
    END
  end


  pdf.font "Courier"
  pdf.text "Word Puzzle", :align => :center, :size => 18
  pdf.move_down 12
  pdf.text "#{word_puzzle}", :align => :center, :size => 10

  pdf.move_down 9
  pdf.column_box([50, pdf.cursor], :align => :center, :columns => 3, :width => pdf.bounds.width) do
    pdf.text(<<-END.gsub(/,/, "\n"))
      #{search_words}
    END
  end


end

finish = Time.now

puts finish - start