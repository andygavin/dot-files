{:user {
        :dependencies [[pjstadig/humane-test-output "0.6.0"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]
        :plugins [
                  [cider/cider-nrepl "0.10.0"]
                  [lein-midje "3.1.3"]
                  [jonase/eastwood "0.2.3"]
                  [refactor-nrepl "1.1.0"]
                  [lein-kibit "0.1.2"]
                  [com.jakemccrary/lein-test-refresh "0.5.5"]
                  [lein-autoexpect "1.4.2"]
                  [lein-ancient "0.5.5"]
                  [lein-kibit "0.0.8"]
                  [lein-pprint "1.1.2"]
                  ]
        :test-refresh {:notify-command ["terminal-notifier" "-title" "Tests" "-message"]}
        :dependencies [[acyclic/squiggly-clojure "0.1.3-SNAPSHOT"]
                       ^:replace [org.clojure/tools.nrepl "0.2.12"]
                       ]
}
}
