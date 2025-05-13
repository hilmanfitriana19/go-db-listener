package listener

import (
	"log"
	"time"

	"github.com/lib/pq"
)

func StartListener(connStr string, channel string, handleFunc func(payload string)) {
	reportProblem := func(ev pq.ListenerEventType, err error) {
		if err != nil {
			log.Printf("❌ Listener error: %v", err)
		}
	}

	listener := pq.NewListener(connStr, 10*time.Second, time.Minute, reportProblem)
	if err := listener.Listen(channel); err != nil {
		log.Fatalf("❌ Failed to listen to channel %s: %v", channel, err)
	}

	log.Printf("📡 Listening on PostgreSQL channel: %s", channel)

	for {
		select {
		case n := <-listener.Notify:
			if n != nil {
				log.Printf("🔔 Received from channel %s: %s", n.Channel, n.Extra)
			}
		case <-time.After(90 * time.Second):
			log.Println("⏱️ Listener timeout, pinging DB to keep connection alive...")
			go listener.Ping()
		}
	}
}
