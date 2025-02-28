import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton instance

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
                Task {
                    self.scheduleDailyNotification()
                }
            } else {
                print("❌ Notification permission denied")
            }
        }
    }

    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])

        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Don't forget to post your daily picture!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 15
        dateComponents.minute = 3

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)

        Task {
            do {
                try await center.add(request)
                print("✅ Daily notification scheduled at 2:45 PM")
            } catch {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
