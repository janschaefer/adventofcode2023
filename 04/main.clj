(ns main
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.set :as set]))

(defn read-lines [filename]
  (with-open [rdr (io/reader filename)]
    (doall (line-seq rdr))))

(defn not-empty-string? [s]
  (not (empty? s)))

(defn parse-cards-string [cards-string]
  (map read-string (filter not-empty-string? (str/split (str/trim cards-string) (re-pattern "[ ]")))))

(defn to-pair-of-numbers [splitted-line]
  [(parse-cards-string (nth splitted-line 1))
   (parse-cards-string (nth splitted-line 2))])

(defn parse-line [line]
  (str/split line (re-pattern "[:|]")))

(defn winning-numbers [pair-of-cards]
  (count (set/intersection (set (first pair-of-cards)) (set (second pair-of-cards)))))

(defn points-per-line [pair-of-cards]
  (Math/pow 2 (- (winning-numbers pair-of-cards) 1)))

(defn solve [filename]
  (println (reduce + (filter #(not= 0.5 %) (map points-per-line (map to-pair-of-numbers (map parse-line (read-lines filename))))))))

(declare get-total-winning-numbers-per-card)

(defn get-plain-winning-numbers [filename]
  (map winning-numbers (map to-pair-of-numbers (map parse-line (read-lines filename)))))

(defn get-total-winning-numbers-for-cards [card-indexes plain-winning-numbers]
  (reduce + (map #(get-total-winning-numbers-per-card % plain-winning-numbers) card-indexes)))

(defn get-total-winning-numbers-per-card [card-index plain-winning-numbers]
  (+ (nth plain-winning-numbers card-index) (get-total-winning-numbers-for-cards (range (+ card-index 1) (+ 1 (+ card-index (nth plain-winning-numbers card-index)))) plain-winning-numbers))) 
  
(defn get-total-numbers-of-cards [plain-winning-numbers]
  (+ (count plain-winning-numbers) (get-total-winning-numbers-for-cards (range 0 (count plain-winning-numbers)) plain-winning-numbers)))

(defn solve2 [filename]
  (println (get-total-numbers-of-cards (get-plain-winning-numbers filename))))

(solve "input")
(solve2 "input")
