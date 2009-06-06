require File.dirname(__FILE__) + '/../../lib/ai4r/som/som'
require 'test/unit'

module Ai4r

  module Som

    class SomTest < Test::Unit::TestCase

      def setup
        @som = Som.new 2, 5, Layer.new(3, 3)
        @som.initiate_map
      end

      def test_random_initiation
        assert_equal 25, @som.nodes.length

        @som.nodes.each do |node|
          assert_equal 2, node.weights.length

          node.weights.each do |weight|
            assert weight < 1
            assert weight > 0
          end

        end
      end


      def test_neighbourhood_for_corner_bmu
        node = @som.get_node(0, 0)
        hood = @som.neighboorhood_for(node, 1)
        assert_equal 4, hood.length

        hood.each do |h|
          dist = h.distance_to_node(node)
          assert dist == 0 || dist == 1
        end
      end

      def test_neighbourhood_for_center_bmu
        node = @som.get_node(2, 2)
        hood = @som.neighboorhood_for(node, 1)
        assert_equal 9, hood.length

        hood.each do |h|
          assert h.distance_to_node(node) == 0 || h.distance_to_node(node) == 1
        end
      end

      # bmu

      def test_find_bmu
        bmu = @som.find_bmu([0.5, 0.5])
      end

      def test_adjust_nodes
        @som.adjust_nodes [1, 2], @som.find_bmu([0.5, 0.5]), 2, 0.1
      end


      def test_access_to_nodes
        assert_raise RuntimeError do
          @som.get_node(5, 5)
        end
        assert_equal Node, @som.get_node(0, 0).class
      end

      def test_distance_for_same_row
        assert_equal 2, distancer(0, 0, 0, 2)
        assert_equal 2, distancer(0, 4, 0, 2)
        assert_equal 0, distancer(0, 0, 0, 0)
      end

      def test_distance_for_same_column
        assert_equal 1, distancer(0, 0, 1, 0)
        assert_equal 2, distancer(2, 0, 0, 0)
      end

      def test_distance_for_diagonally_point
        assert_equal 1, distancer(1, 0, 0, 1)
        assert_equal 2, distancer(2, 2, 0, 0)
        assert_equal 2, distancer(3, 2, 1, 4)
      end

      def test_distance_for_screwed_diagonally_point
        assert_equal 2, distancer(0, 0, 2, 1)
        assert_equal 4, distancer(3, 4, 1, 0)
        assert_equal 2, distancer(3, 2, 1, 3)
      end

      private

      def distancer(x1, y1, x2, y2)
        @som.get_node(x1, y1).distance_to_node(@som.get_node(x2, y2))
      end

    end

  end

end