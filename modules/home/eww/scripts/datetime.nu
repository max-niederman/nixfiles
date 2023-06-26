#!/usr/bin/env nu

def main [] {}

def "main notify" [] {
   loop {
      date now | format-datetime | to json -r | print
      sleep 1sec
   }
}

def format-datetime [] {
   {
      date: ($in | date format "%a, %h %e") 
      time: ($in | date format "%H:%M")
   }
}