table = require "src.table"

describe "supermoon", ->

  describe "table", ->

    describe "deepcopy", ->
      it "deep copies", ->
        person = {
          name: {
            first: "Douglas"
            middle: "Noel"
            last: "Adams"
          }
          birth: "11 March 1952"
          death: "11 May 2001"
        }

        clone = table.deepcopy person
        assert.are.equal        person.birth, clone.birth
        assert.are.equal        person.death, clone.death
        assert.are.not_equal    person.name,  clone.name
        assert.are.same         person.name,  clone.name

    describe "filter", ->
      it "filters tables", ->
        channels = {
          ["NBC"]: 1939
          ["ABC"]: 1948
          ["CBS"]: 1941
          ["Fox"]: 1986
        }

        selection = table.filter channels, (source, key, value) ->
          value < 1950

        assert.are_equal      channels["NBC"], selection["NBC"]
        assert.are_equal      channels["ABC"], selection["ABC"]
        assert.are_equal      channels["CBS"], selection["CBS"]
        assert.are_not_equal  channels["Fox"], selection["Fox"]
        assert.is_nil         selection["Fox"]

    describe "filtersequence", ->
      it "filters sequences", ->
        brackets = {"(", ")", "<", ">", "[", "]"}
        selection = table.filtersequence brackets, (source, index, value) ->
          string.byte(value) % 2 == 0

        assert.are_equal      brackets[1], selection[1]
        assert.are_equal      brackets[3], selection[2]
        assert.are_equal      brackets[4], selection[3]
        assert.is_nil         selection[4]

        assert.is_true table.issequential selection

    describe "issequential", ->
      it "determines proper sequences", ->
        is, index = table.issequential {"h", "e", "l", "l", "o"}
        assert.is_true    is
        assert.are_equal  index, 5

        is, index = table.issequential {"w", nil, "r", "l", "d"}
        assert.is_false   is
        assert.are_equal  index, 2

    describe "merge", ->
      it "combines tables", ->
        a = table.merge {a: 1, b: 2, c: 3, "do", "re", "mi"},
          {"u", "n", "me"}

        assert.are_equal  a.a,  1
        assert.are_equal  a.b,  2
        assert.are_equal  a.c,  3
        assert.are_equal  a[1], "u"
        assert.are_equal  a[2], "n"
        assert.are_equal  a[3], "me"

    describe "shallowcopy", ->
      it "shallow copies", ->
        person = {
          name: {
            first: "Douglas"
            middle: "Noel"
            last: "Adams"
          }
          birth: "11 March 1952"
          death: "11 May 2001"
        }

        clone = table.shallowcopy person
        assert.are.equal        person.birth, clone.birth
        assert.are.equal        person.death, clone.death
        assert.are.equal        person.name,  clone.name
