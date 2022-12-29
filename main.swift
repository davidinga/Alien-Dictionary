/*
There is a new alien language that uses the English alphabet. However, the order among the letters is unknown to you.

You are given a list of strings words from the alien language's dictionary, where the strings in words are 
sorted lexicographically
 by the rules of this new language.

Return a string of the unique letters in the new alien language sorted in lexicographically increasing order by the new language's rules. If there is no solution, return "". If there are multiple solutions, return any of them.

Example 1:

Input: words = ["wrt","wrf","er","ett","rftt"]
Output: "wertf"
Example 2:

Input: words = ["z","x"]
Output: "zx"
Example 3:

Input: words = ["z","x","z"]
Output: ""
Explanation: The order is invalid, so return "".

Constraints:

1 <= words.length <= 100
1 <= words[i].length <= 100
words[i] consists of only lowercase English letters.

Problem:
- Given array of strings in sorted order, output string of letters
  in alphabetical order of the alien language.

Questions:
- Assume no empty strings.
- Assume words are in sorted order? Can be unsorted.
- Assume words and output fits in memory.
- Can we be given uppercase and lowercase letters?

Input: [String]
Output: String

Examples:
                  l
- Input: ["app", "store", "iPhone"]
                           r
- Output: "asi"

Algorithm:
- Topological Sort with DFS
    - Build Graph
        - Dictionary with adjacency array
        - Eval pairs of words at a time
            - Iterate over pair from left to right
            - When first difference in pair occurs
              add edge to Dictionary
    - Traverse Graph
        - Result string
        - State Dictionary: unprocessed, processing, processed
            - If visit proccesing vertice, the graph is invalid
        - Once vertice has been processed, append to result
        - Return result string reversed

*/

enum State: Int {
    case unprocessed
    case processing
    case processed
}

func alienOrder(_ words: [String]) -> String {
    var result: String = ""
    var adjList: [Character: Set<Character>] = [:]
    var visited: [Character: State] = [:]
    
    func buildGraph() -> Bool {
        for word in words {
            for char in word {
                adjList[char] = []
                visited[char] = .unprocessed
            }
        }

        for i in words.indices where i > 0 {
            for (char1, char2) in zip(words[i - 1], words[i]) {
                if char1 != char2 {
                    adjList[char1, default: []].insert(char2)
                    break
                } else {
                    if words[i - 1].count != words[i].count, words[i - 1].hasPrefix(words[i]) {
                        return false
                    }
                }
            }
        }

        return true
    }

    func topoSort(_ root: Character) -> Bool {
        if visited[root] == .processing { return false }
        visited[root] = .processing

        for neighbor in adjList[root] ?? [] {
            if visited[neighbor] != .processed {
                if !topoSort(neighbor) {
                    return false
                }
            }
        }

        visited[root] = .processed
        result.append(root)

        return true
    }

    if !buildGraph() { return "" }

    for char in adjList.keys {
        if visited[char] != .processed {
            if !topoSort(char) {
                return ""
            }
        }
    }

    return String(result.reversed())
}