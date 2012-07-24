(ns howaboutthatweather.views.common
  (:use [noir.core :only [defpartial]]
        [hiccup.page-helpers :only [include-css html5]]))

(defpartial layout [& content]
            (html5
              [:head
               [:title "howaboutthatweather"]
               (include-css "/css/reset.css")]
              [:body
               [:div#wrapper
                content]]))

(defpartial site-layout [& content]
  (html5
   [:head
    [:title "How about that weather?"]
    [:meta { :name "viewport" :content "width=device-width, initial-scale=1.0" }]
    ]
   [:body
    [:div#header
     [:div.row
      [:h1.twelve.phone-four.columns.align-center "How about that Weather?"]
      ]]
    [:div.row
           content]]))