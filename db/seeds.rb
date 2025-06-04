subjects_data = [
  # Programming Languages
  { name: "Ruby cơ bản", description: "Ngôn ngữ Ruby cho người mới bắt đầu." },
  { name: "Python nâng cao", description: "Kỹ thuật lập trình Python chuyên sâu." },
  { name: "JavaScript hiện đại", description: "ES6+ và các tính năng JavaScript mới." },
  { name: "Java cốt lõi", description: "Nền tảng lập trình với ngôn ngữ Java." },
  { name: "Lập trình C++", description: "Tìm hiểu ngôn ngữ C++ và ứng dụng." },
  { name: "Go (Golang) căn bản", description: "Giới thiệu về ngôn ngữ Go của Google." },
  { name: "Swift cho iOS", description: "Phát triển ứng dụng iOS với ngôn ngữ Swift." },
  { name: "Kotlin cho Android", description: "Lập trình ứng dụng Android hiện đại với Kotlin." },
  { name: "PHP & MySQL", description: "Phát triển web động với PHP và MySQL." },

  # Web Development
  { name: "HTML & CSS từ A-Z", description: "Xây dựng cấu trúc và giao diện web." },
  { name: "ReactJS toàn tập", description: "Tạo UI động và hiệu quả với ReactJS." },
  { name: "VueJS Framework", description: "Học VueJS để phát triển frontend." },
  { name: "Angular căn bản", description: "Kiến trúc ứng dụng frontend với Angular." },
  { name: "Node.js & Express", description: "Xây dựng backend API bằng JavaScript." },
  { name: "Ruby on Rails", description: "Framework phát triển web nhanh với Ruby." },
  { name: "Django cơ bản", description: "Phát triển web với Python và Django." },
  { name: "API với FastAPI", description: "Tạo API hiệu suất cao bằng Python FastAPI." },
  { name: "Thiết kế Web Responsive", description: "Kỹ thuật tạo web tương thích mọi thiết bị." },

  # Databases
  { name: "SQL căn bản", description: "Ngôn ngữ truy vấn cơ sở dữ liệu SQL." },
  { name: "PostgreSQL quản trị", description: "Quản trị và tối ưu CSDL PostgreSQL." },
  { name: "MongoDB NoSQL", description: "Làm việc với cơ sở dữ liệu NoSQL MongoDB." },

  # Mobile Development
  { name: "Lập trình Android", description: "Phát triển ứng dụng cho nền tảng Android." },
  { name: "Lập trình iOS", description: "Xây dựng ứng dụng cho iPhone và iPad." },
  { name: "React Native", description: "Phát triển app đa nền tảng với React Native." },

  # DevOps & Cloud
  { name: "Docker cơ bản", description: "Container hóa ứng dụng với Docker." },
  { name: "Kubernetes nhập môn", description: "Điều phối container với Kubernetes." },
  { name: "AWS Cloud căn bản", description: "Các dịch vụ đám mây cơ bản của AWS." },
  { name: "CI/CD với Jenkins", description: "Tự động hóa quy trình CI/CD." },

  # Data Science & AI
  { name: "Nhập môn Trí tuệ nhân tạo", description: "Tổng quan về lĩnh vực AI." },
  { name: "Machine Learning ứng dụng", description: "Các thuật toán và ứng dụng học máy." },
  { name: "Phân tích dữ liệu với Pandas", description: "Thư viện Pandas trong Python cho phân tích." },

  # Software Engineering & Design
  { name: "Nguyên lý SOLID", description: "Các nguyên lý thiết kế phần mềm hướng đối tượng." },
  { name: "Agile & Scrum", description: "Phương pháp quản lý dự án linh hoạt." },
  { name: "UI/UX Design cơ bản", description: "Nguyên tắc thiết kế giao diện và trải nghiệm." },
  { name: "Git & Github", description: "Hệ thống quản lý phiên bản phân tán." }
]

new_subjects_count = 0
subjects_data.each do |subject_attrs|
  Subject.find_or_create_by!(name: subject_attrs[:name]) do |s|
    s.description = subject_attrs[:description]
    new_subjects_count += 1
  end
end

puts "\n--- Subject Seeding Summary ---"
puts "Total subject definitions processed: #{subjects_data.length}"
puts "Newly created subjects (this run): #{new_subjects_count}"
puts "Total subjects in DB: #{Subject.count}"
puts "Finished seeding subjects."
