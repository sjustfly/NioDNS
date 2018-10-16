import NIO

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
let dnsClient = try NioDNS.connect(on: group, host: "8.8.8.8").wait()
print("Connected")

func query() -> Message {
    let header = MessageHeader(id: 0x6e08, options: [.standardQuery, .recursionDesired], questionCount: 1, answerCount: 0, authorityCount: 0, additionalRecordCount: 0)
    let question = QuestionSection(labels: ["google", "com"], type: .a, questionClass: .internet)
    return Message(header: header, questions: [question])
}

func status() -> Message {
    let header = MessageHeader(id: 1, options: [.serverStatusQuery], questionCount: 0, answerCount: 0, authorityCount: 0, additionalRecordCount: 0)
    return Message(header: header, questions: [])
}

dnsClient.sendMessage(query())

sleep(10)

//labels          63 octets or less
//
//names           255 octets or less
//
//TTL             positive values of a signed 32 bit number.