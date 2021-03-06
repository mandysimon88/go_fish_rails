require 'rails_helper'

describe Card do
  describe "#initialize" do
    it 'creates a card with a readable rank and suit and sets an image if possible' do
      my_card = Card.new(rank: "seven", suit: "clubs")
      expect(my_card.rank).to eq "seven"
      expect(my_card.suit).to eq "clubs"
      expect(my_card.icon).to be > ""
    end
  end

  describe '.deck' do
    it 'returns a deck containing four cards of every rank, thirteen cards of every suit, and no two equal cards' do
      deck = Card.deck
      rank_totals = Hash.new(0)
      suit_totals = Hash.new(0)
      deck.cards.each do |card|
        rank_totals[card.rank] += 1
        suit_totals[card.suit] += 1
      end
      rank_totals.values.each { |rank_total| expect(rank_total).to eq Card::SUITS.size }
      suit_totals.values.each { |suit_total| expect(suit_total).to eq Card::RANKS.size }
      expect(deck.cards.uniq).to eq(deck.cards)
    end
  end

  context 'cards are already made' do
    let(:card_7h_dupl) { build(:card_7h) }
    let(:irregular_card) { build(:card, rank: "fake_rank", suit: "fake_suit") }
    cards = [:card_7h, :card_7s, :card_ah]
    cards.each { |card| let(card) { build(card) } }

    describe "#rank_value" do
      it 'returns the numeric value of the rank' do
        expect(card_7h.rank_value).to eq 7
      end

      it 'works for face cards' do
        expect(card_ah.rank_value).to eq 14
      end

      it 'returns zero for cards outside the deck naming scheme' do
        expect(irregular_card.rank_value).to eq 0
      end
    end

    describe '#==, #eql?' do
      it 'returns true for any two cards of the same rank and suit' do
        expect(card_7h == card_7h_dupl).to be true
        expect(card_7h.eql?(card_7h_dupl)).to be true
      end

      it 'returns false if suit is different' do
        expect(card_7h == card_7s).to be false
        expect(card_7h.eql?(card_7s)).to be false
      end

      it 'returns false if rank is different' do
        expect(card_ah == card_7h).to be false
        expect(card_ah.eql?(card_7h)).to be false
      end

      it 'returns false if both rank and suit are different' do
        expect(card_ah == card_7s).to be false
        expect(card_ah.eql?(card_7s)).to be false
      end
    end

    describe '#hash' do
      it 'returns the same hash for two cards of same rank and suit but different object ids' do
        expect(card_7h.hash == card_7h_dupl.hash).to be true
      end

      it 'returns a different hash for two cards of different rank or suit' do
        [card_7h, card_ah, card_7s].combination(2) { |cards| expect(cards[0].hash == cards[1].hash).to be false }
      end
    end

    describe '#to_s' do
      it 'returns the string value of the rank and suit of a card' do
        expect(card_7s.to_s).to eq "the seven of spades"
      end
    end

    describe '#to_json' do
      it 'returns hash of rank and suit' do
        expect(card_7s.to_json).to eq("{\"rank\":\"seven\",\"suit\":\"spades\",\"icon\":\"/assets/cards/s7.png\"}")
      end
    end

    describe '#set_icon' do
      it 'returns an icon image path based on the rank and suit of the card' do
        expect(card_7s.set_icon).to eq "/assets/cards/#{card_7s.suit[0]}#{card_7s.rank_value}.png"
      end

      it 'returns nil for irregular cards' do
        expect(irregular_card.set_icon).to eq nil
      end
    end
  end
end
