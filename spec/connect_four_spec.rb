require_relative '../lib/connect_four'

describe Board do
  subject(:test_board) { described_class.new }

  describe '#initialize' do
    it 'creates an empty board' do
      expect(test_board.board).to eq([['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                      ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                      ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                      ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                      ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                      ['☐', '☐', '☐', '☐', '☐', '☐', '☐']])
    end
  end

  describe '#switch_player' do
    before do
      test_board.instance_variable_set(:@current_player, test_board.player1)
    end

    it 'changes to the other player' do
      player1 = test_board.player1
      player2 = test_board.player2
      expect { test_board.change_player }.to change { test_board.current_player }.to(player2)
    end
  end

  describe '#assign_move' do
    before do
      test_board.instance_variable_set(:@current_player, test_board.player2)
      allow(test_board.current_player).to receive(:choose_move).and_return(4, 5)
    end

    context 'when the chosen column is empty' do
      it 'places token in the bottom row' do
        board = test_board.board
        expect { test_board.assign_move }
          .to change { board }.to([['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                   ['☐', '☐', '☐', '◆', '☐', '☐', '☐']])
      end
    end

    context 'when the chosen column has a token already' do
      before do
        test_board.instance_variable_set(:@board, [['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐']])
      end

      it 'places token above the already placed tokens' do
        board = test_board.board
        expect { test_board.assign_move }
               .to change { board }.to([['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '◆', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '◇', '☐', '☐', '☐']])
      end
    end

    context 'when the chosen column is full' do
      before do
        test_board.instance_variable_set(:@board, [['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◆', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◆', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐']])
        allow(test_board).to receive(:puts)
      end

      it 'puts an error and requests an unfilled column' do
        board = test_board.board
        expect { test_board.assign_move }
               .to change { board }.to([['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '◆', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '◆', '☐', '☐', '☐'],
                                        ['☐', '☐', '☐', '◇', '◆', '☐', '☐']])
        expect(test_board).to have_received(:puts).with('Column already full. Please choose another:').once
      end
    end
  end

  describe '#game_over?' do
    context 'when no player has 4 in a row' do
      before do
        test_board.instance_variable_set(:@board, [['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '◇', '☐', '☐'],
                                                   ['☐', '◆', '◆', '◆', '☐', '◇', '☐'],
                                                   ['☐', '☐', '☐', '◆', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐']])
      end

      it 'returns false' do
        expect(test_board).not_to be_game_over
      end
    end

    context 'when a player has 4 in a row horizontally' do
      before do
        test_board.instance_variable_set(:@board, [['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['◆', '◆', '◆', '◆', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◆', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐']])
      end

      it 'declares a winner' do
        expect(test_board).to be_game_over
      end
    end

    context 'when a player has 4 in a row vertically' do
      before do
        test_board.instance_variable_set(:@board, [['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['◆', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['◆', '◆', '◆', '☐', '☐', '☐', '☐'],
                                                   ['◆', '☐', '☐', '◆', '☐', '☐', '☐'],
                                                   ['◆', '☐', '☐', '◇', '☐', '☐', '☐']])
      end

      it 'declares a winner' do
        expect(test_board).to be_game_over
      end
    end

    context 'when a player has 4 in a row diagonally' do
      before do
        test_board.instance_variable_set(:@board, [['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '☐'],
                                                   ['☐', '☐', '☐', '◇', '☐', '☐', '◇'],
                                                   ['◆', '◆', '◆', '☐', '☐', '◇', '☐'],
                                                   ['◆', '☐', '☐', '◆', '◇', '☐', '☐'],
                                                   ['◆', '☐', '☐', '◇', '☐', '☐', '☐']])
      end

      it 'declares a winner' do
        expect(test_board).to be_game_over
      end
    end
  end
end

describe Player do
  subject(:test) { described_class.new('Black', '◆') }

  describe '#initialize' do
    it 'assigns name and symbol' do
      expect(test.name).to eq('Black')
      expect(test.symbol).to eq('◆')
    end
  end

  describe '#choose_move' do
    context 'when black chooses a position' do
      before do
        allow(test).to receive(:puts)
        allow(test).to receive(:gets).and_return('4')
      end

      it 'updates @move with player column choice' do
        expect(test.choose_move).to eq(4)
      end
    end
  end
end
