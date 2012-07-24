(ns howaboutthatweather.views.welcome
  (:require [howaboutthatweather.views.common :as common])

  (:use [noir.core :only [defpage]]
        [hiccup.core :only [html]]))

(defpage "/welcome" []
         (common/layout
           [:p "Welcome to howaboutthatweather"]))

(defpage "/my-page" []
  (common/site-layout
   [:h1 "Welcome to my site!"]
   [:p "Hope you like it"] ))
