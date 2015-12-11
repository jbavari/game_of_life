require 'spec_helper'
require 'arena.rb'

RSpec.describe Arena do
  context do
    subject(:arena) do
      Arena.new(5, 5)
    end

    it 'can be constructed' do
      expect(described_class.new).not_to be_nil
    end

    it 'has size it was initialized with' do
      expect(arena.playing_field.length).to eq 5
      expect(arena.playing_field[0].length).to eq 5
    end

    it 'initializes with all dead cells' do
      (0..(arena.width - 1)).each_with_index do |_row, r_index|
        (0..(arena.height - 1)).each_with_index do |_column, c_index|
          expect(arena.status(r_index, c_index)).to eq false
        end
      end
    end

    it 'can set status' do
      expect(arena.set_status(0, 0, true)).to eq true
      expect(arena.status(0, 0)).to eq true
    end

    it 'does not set any other life status' do
      expect(arena.status(0, 0)).to eq false
      expect(arena.set_status(0, 0, true)).to eq true
      expect(arena.status(0, 0)).to eq true
      expect(arena.status(1, 0)).to eq false
      expect(arena.status(2, 0)).to eq false
    end
  end

  # > * , as if caused by underpopulation.
  context 'Any live cell with fewer than two live neighbours dies' do
    subject(:arena) { Arena.new(5, 5) }
    before do
      arena.set_status(0, 99, true)
    end

    it 'can get status' do
      expect(arena.status(0, 99)).to eq true
    end

    it 'status should be false on next generation' do
      arena.next_day
      expect(arena.status(0, 99)).to eq false
    end
  end

  # > * Any live cell with two or three live neighbours
  # lives on to the next generation.
  context do
    subject(:arena) { Arena.new(5, 5) }

    before do
      arena.set_status(0, 0, true)
      arena.set_status(0, 1, true)
      arena.set_status(1, 0, true)
    end

    it 'status should be alive on next generation' do
      arena.next_day
      expect(arena.status(1, 1)).to eq true
    end
  end

  # > * Any live cell with more than three live neighbours dies,
  # as if by overcrowding.
  context do
    subject(:arena) { Arena.new(5, 5) }

    before do
      arena.set_status(0, 0, true)
      arena.set_status(0, 1, true)
      arena.set_status(0, 2, true)
      arena.set_status(1, 0, true)
      arena.set_status(1, 1, true)
    end

    it 'status should be dead on next generation' do
      arena.next_day
      expect(arena.status(1, 1)).to eq false
    end
  end

  # > * Any dead cell with exactly three live neighbours becomes a live cell.
  context 'dead cell with three live neighbours becomes alive' do
    subject(:arena) { Arena.new(5, 5) }
    before do
      arena.set_status(0, 0, true)
      arena.set_status(0, 1, true)
      arena.set_status(1, 0, true)
    end

    it 'dead cell should be alive on next generation' do
      arena.next_day
      expect(arena.status(1, 1)).to eq true
    end
  end
end
