#!/bin/env ruby
# encoding: ISO-8859-1

require "ruby-tf-idf/version"

module RubyTfIdf

  class TfIdf

    STOP_WORDS_EN = [
      'a','cannot','into','our','thus','about','co','is','ours','to','above',
      'could','it','ourselves','together','across','down','its','out','too',
      'after','during','itself','over','toward','afterwards','each','last','own',
      'towards','again','eg','latter','per','under','against','either','latterly',
      'perhaps','until','all','else','least','rather','up','almost','elsewhere',
      'less','same','upon','alone','enough','ltd','seem','us','along','etc',
      'many','seemed','very','already','even','may','seeming','via','also','ever',
      'me','seems','was','although','every','meanwhile','several','we','always',
      'everyone','might','she','well','among','everything','more','should','were',
      'amongst','everywhere','moreover','since','what','an','except','most','so',
      'whatever','and','few','mostly','some','when','another','first','much',
      'somehow','whence','any','for','must','someone','whenever','anyhow',
      'former','my','something','where','anyone','formerly','myself','sometime',
      'whereafter','anything','from','namely','sometimes','whereas','anywhere',
      'further','neither','somewhere','whereby','are','had','never','still',
      'wherein','around','has','nevertheless','such','whereupon','as','have',
      'next','than','wherever','at','he','no','that','whether','be','hence',
      'nobody','the','whither','became','her','none','their','which','because',
      'here','noone','them','while','become','hereafter','nor','themselves','who',
      'becomes','hereby','not','then','whoever','becoming','herein','nothing',
      'thence','whole','been','hereupon','now','there','whom','before','hers',
      'nowhere','thereafter','whose','beforehand','herself','of','thereby','why',
      'behind','him','off','therefore','will','being','himself','often','therein',
      'with','below','his','on','thereupon','within','beside','how','once',
      'these','without','besides','however','one','they','would','between','i',
      'only','this','yet','beyond','ie','onto','those','you','both','if','or',
      'though','your','but','in','other','through','yours','by','inc','others',
      'throughout','yourself','can','indeed','otherwise','thru','yourselves'
    ]

    STOP_WORDS_FR = [

      '-elle','-il','à','a','afin','ai','ainsi','ais','ait','alors','après','as','assez','au','aucun',
      'aucune','auprès','auquel','auquelles','auquels','auraient','aurais','aurait','aurez',
      'auriez','aurions','aurons','auront','aussi','aussitôt','autre','autres','aux',
      'avaient','avais','avait','avant','avec','avez','aviez','avoir','avons','ayant',
      'beaucoup','c','car','ce','ceci','cela','celle','celles','celui','cependant',
      'certes','ces','cet','cette','ceux','chacun','chacune','chaque','chez','cinq',
      'comme','d','abord','dans','de','dehors','delà','depuis','des','dessous',
      'dessus','deux','deça','dix','doit','donc','dont','du','durant','dès','déjà',
      'elle','elles','en','encore','enfin','entre','er','est','est-ce','et','etc',
      'eu','eurent','eut','faut','fur','hormis','hors','huit','il','ils','j','je',
      'jusqu','l','la','laquelle','le','lequel','les','lesquels','leur','leurs',
      'lors','lorsque','lui','là','m','mais','malgré','me','melle','mes','mm','mme',
      'moi','moins','mon','mr','même','mêmes','n','neuf','ni','non-','nos','notamment',
      'notre','nous','néanmoins','nôtres','on','ont','ou','où','par','parce','parfois',
      'parmi','partout','pas','pendant','peu','peut','peut-être','plus','plutôt','pour',
      'pourquoi','près','puisqu','puisque','qu','quand','quant','quatre','que','quel',
      'quelle','quelles','quelqu','quelque','quelquefois','quelques','quels','qui',
      'quoi','quot','s','sa','sans','se','sept','sera','serai','seraient','serais',
      'serait','seras','serez','seriez','serions','serons','seront','ses','si','sien',
      'siennes','siens','sitôt','six','soi','sommes','son','sont','sous','souvent',
      'suis','sur','t','toi','ton','toujours','tous','tout','toutefois','toutes',
      'troiw','tu','un','une','unes','uns','voici','voilà','vos','votre','vous','vôtres',
      'y','à','ème','étaient','étais','était','étant','étiez','étions','êtes','être',
      'afin','ainsi','alors','après','aucun','aucune','auprès','auquel','aussi','autant',
      'aux','avec','car','ceci','cela','celle','celles','celui','cependant','ces',
      'cet','cette','ceux','chacun','chacune','chaque','chez','comme','comment','dans',
      'des','donc','donné','dont','duquel','dès','déjà','elle','elles','encore','entre',
      'étant','etc','été','eux','furent','grâce','hors','ici','ils','jusqu','les','leur',
      'leurs','lors','lui','mais','malgré','mes','mien','mienne','miennes','miens',
      'moins','moment','mon','même','mêmes','non','nos','notre','notres','nous','notre',
      'oui','par','parce','parmi','plus','pour','près','puis','puisque','quand','quant',
      'que','quel','quelle','quelque','quelquun','quelques','quels','qui','quoi','sans',
      'sauf','selon','ses','sien','sienne','siennes','siens','soi','soit','sont','sous',
      'suis','sur','tandis','tant','tes','tienne','tiennes','tiens','toi','ton','tous',
      'tout','toute','toutes','trop','très','une','vos','votre','vous','étaient','était',
      'étant','être'
    ]

    STOP_WORDS_ID = [
      'yang', 'di', 'dan', 'itu', 'dengan', 'untuk', 'tidak', 'ini', 'dari', 'dalam', 'akan',
      'pada', 'juga', 'saya', 'ke', 'karena', 'tersebut', 'bisa', 'ada', 'mereka', 'lebih',
      'kata', 'tahun', 'sudah', 'atau', 'saat', 'oleh', 'menjadi', 'orang', 'ia', 'telah',
      'adalah', 'seperti', 'sebagai', 'bahwa', 'dapat', 'para', 'harus', 'namun', 'kita', 'dua',
      'satu', 'hari', 'hanya', 'mengatakan', 'kepada', 'kami', 'setelah', 'melakukan',
      'lalu', 'belum', 'lain', 'dia', 'kalau', 'terjadi', 'banyak', 'menurut', 'anda', 'hingga',
      'tak', 'baru', 'beberapa', 'ketika', 'saja', 'jalan', 'sekitar', 'secara', 'dilakukan',
      'sementara', 'tapi', 'sangat', 'hal', 'sehingga', 'seorang', 'bagi', 'besar', 'lagi', 'selama',
      'antara', 'waktu', 'sebuah', 'jika', 'sampai', 'jadi', 'terhadap', 'tiga', 'serta', 'pun',
      'salah', 'merupakan', 'atas', 'sejak', 'membuat', 'baik', 'memiliki', 'kembali', 'selain',
      'tetapi', 'pertama', 'kedua', 'memang', 'pernah', 'apa', 'mulai', 'sama', 'tentang', 'bukan',
      'agar', 'semua', 'sedang', 'kali', 'kemudian', 'hasil', 'sejumlah', 'juta', 'persen', 'sendiri',
      'katanya', 'demikian', 'masalah', 'mungkin', 'umum', 'setiap', 'bulan', 'bagian', 'bila', 'lainnya',
      'terus', 'luar', 'cukup', 'termasuk', 'sebelumnya', 'bahkan', 'wib', 'tempat', 'perlu',
      'menggunakan', 'memberikan', 'rabu', 'sedangkan', 'kamis', 'langsung', 'apakah', 'pihak', 'melalui',
      'diri', 'mencapai', 'minggu', 'aku', 'berada', 'tinggi', 'ingin', 'sebelum', 'tengah', 'kini',
      'tahu', 'bersama', 'depan', 'selasa', 'begitu', 'merasa', 'berbagai', 'mengenai', 'maka', 'jumlah',
      'masuk', 'katanya', 'mengalami', 'sering', 'ujar', 'kondisi', 'akibat', 'hubungan', 'empat',
      'paling', 'mendapatkan', 'selalu', 'lima', 'meminta', 'melihat', 'sekarang', 'mengaku', 'mau',
      'kerja', 'acara', 'menyatakan', 'masa', 'proses', 'tanpa', 'selatan', 'sempat', 'adanya', 'hidup',
      'datang', 'senin', 'rasa', 'maupun', 'seluruh', 'mantan', 'lama', 'jenis', 'segera', 'misalnya',
      'mendapat', 'bawah', 'jangan', 'meski', 'terlihat', 'akhirnya', 'jumat', 'punya', 'yakni',
      'terakhir', 'kecil', 'panjang', 'badan', 'juni', 'jelas', 'jauh', 'tentu', 'semakin', 'tinggal',
      'kurang', 'mampu', 'posisi', 'asal', 'sekali', 'sesuai', 'sebesar', 'berat', 'dirinya', 'memberi',
      'pagi', 'sabtu', 'ternyata', 'mencari', 'sumber', 'ruang', 'menunjukkan', 'biasanya', 'nama',
      'sebanyak', 'utara', 'berlangsung', 'barat', 'kemungkinan', 'yaitu', 'berdasarkan', 'sebenarnya',
      'cara', 'utama', 'pekan', 'terlalu', 'membawa', 'kebutuhan', 'suatu', 'menerima', 'penting',
      'tanggal', 'bagaimana', 'terutama', 'tingkat', 'awal', 'sedikit', 'nanti', 'pasti', 'muncul',
      'lanjut', 'ketiga', 'biasa', 'dulu', 'kesempatan', 'ribu', 'akhir', 'membantu', 'terkait', 'sebab',
      'menyebabkan', 'khusus', 'bentuk', 'ditemukan', 'diduga', 'mana', 'ya', 'kegiatan', 'sebagian',
      'tampil', 'hampir', 'bertemu', 'usai', 'berarti', 'keluar', 'pula', 'digunakan', 'justru',
      'padahal', 'menyebutkan', 'gedung', 'apalagi', 'program', 'milik', 'teman', 'menjalani',
      'keputusan', 'sumber', 'upaya', 'mengetahui', 'mempunyai', 'berjalan', 'menjelaskan', 'mengambil',
      'benar', 'lewat', 'belakang', 'ikut', 'barang', 'meningkatkan', 'kejadian', 'kehidupan',
      'keterangan', 'penggunaan', 'masing-masing', 'menghadapi'
    ]

    STOP_WORDS_ID_V2 = [
      "adalah", "adanya", "adapun", "agak", "agaknya", "agar", "akan", "akankah", "akhir", "akhiri", "akhirnya",
      "aku", "akulah", "amat", "amatlah", "anda", "andalah", "antar", "antara", "antaranya", "apa", "apaan",
      "apabila", "apakah", "apalagi", "apatah", "artinya", "asal", "asalkan", "atas", "atau", "ataukah", "ataupun",
      "awal", "awalnya", "bagai", "bagaikan", "bagaimana", "bagaimanakah", "bagaimanapun", "bagi", "bagian", "bahkan",
      "bahwa", "bahwasanya", "baik", "bakal", "bakalan", "balik", "banyak", "bapak", "baru", "bawah", "beberapa",
      "begini", "beginian", "beginikah", "beginilah", "begitu", "begitukah", "begitulah", "begitupun", "bekerja",
      "belakang", "belakangan", "belum", "belumlah", "benar", "benarkah", "benarlah", "berada", "berakhir",
      "berakhirlah", "berakhirnya", "berapa", "berapakah", "berapalah", "berapapun", "berarti", "berawal", "berbagai",
      "berdatangan", "beri", "berikan", "berikut", "berikutnya", "berjumlah", "berkali-kali", "berkata", "berkehendak",
      "berkeinginan", "berkenaan", "berlainan", "berlalu", "berlangsung", "berlebihan", "bermacam", "bermacam-macam",
      "bermaksud", "bermula", "bersama", "bersama-sama", "bersiap", "bersiap-siap", "bertanya", "bertanya-tanya",
      "berturut", "berturut-turut", "bertutur", "berujar", "berupa", "besar", "betul", "betulkah", "biasa", "biasanya",
      "bila", "bilakah", "bisa", "bisakah", "boleh", "bolehkah", "bolehlah", "buat", "bukan", "bukankah", "bukanlah",
      "bukannya", "bulan", "bung", "cara", "caranya", "cukup", "cukupkah", "cukuplah", "cuma", "dahulu", "dalam", "dan",
      "dapat", "dari", "daripada", "datang", "dekat", "demi", "demikian", "demikianlah", "dengan", "depan", "di", "dia",
      "diakhiri", "diakhirinya", "dialah", "diantara", "diantaranya", "diberi", "diberikan", "diberikannya", "dibuat",
      "dibuatnya", "didapat", "didatangkan", "digunakan", "diibaratkan", "diibaratkannya", "diingat", "diingatkan",
      "diinginkan", "dijawab", "dijelaskan", "dijelaskannya", "dikarenakan", "dikatakan", "dikatakannya", "dikerjakan",
      "diketahui", "diketahuinya", "dikira", "dilakukan", "dilalui", "dilihat", "dimaksud", "dimaksudkan", "dimaksudkannya",
      "dimaksudnya", "diminta", "dimintai", "dimisalkan", "dimulai", "dimulailah", "dimulainya", "dimungkinkan", "dini",
      "dipastikan", "diperbuat", "diperbuatnya", "dipergunakan", "diperkirakan", "diperlihatkan", "diperlukan",
      "diperlukannya", "dipersoalkan", "dipertanyakan", "dipunyai", "diri", "dirinya", "disampaikan", "disebut", "disebutkan",
      "disebutkannya", "disini", "disinilah", "ditambahkan", "ditandaskan", "ditanya", "ditanyai", "ditanyakan", "ditegaskan",
      "ditujukan", "ditunjuk", "ditunjuki", "ditunjukkan", "ditunjukkannya", "ditunjuknya", "dituturkan", "dituturkannya",
      "diucapkan", "diucapkannya", "diungkapkan", "dong", "dua", "dulu", "empat", "enggak", "enggaknya", "entah", "entahlah",
      "guna", "gunakan", "hal", "hampir", "hanya", "hanyalah", "hari", "harus", "haruslah", "harusnya", "hendak", "hendaklah",
      "hendaknya", "hingga", "ia", "ialah", "ibarat", "ibaratkan", "ibaratnya", "ibu", "ikut", "ingat", "ingat-ingat",
      "ingin", "inginkah", "inginkan", "ini", "inikah", "inilah", "itu", "itukah", "itulah", "jadi", "jadilah", "jadinya",
      "jangan", "jangankan", "janganlah", "jauh", "jawab", "jawaban", "jawabnya", "jelas", "jelaskan", "jelaslah", "jelasnya",
      "jika", "jikalau", "juga", "jumlah", "jumlahnya", "justru", "kala", "kalau", "kalaulah", "kalaupun", "kalian", "kami",
      "kamilah", "kamu", "kamulah", "kan", "kapan", "kapankah", "kapanpun", "karena", "karenanya", "kasus", "kata", "katakan",
      "katakanlah", "katanya", "ke", "keadaan", "kebetulan", "kecil", "kedua", "keduanya", "keinginan", "kelamaan",
      "kelihatan", "kelihatannya", "kelima", "keluar", "kembali", "kemudian", "kemungkinan", "kemungkinannya", "kenapa",
      "kepada", "kepadanya", "kesampaian", "keseluruhan", "keseluruhannya", "keterlaluan", "ketika", "khususnya", "kini",
      "kinilah", "kira", "kira-kira", "kiranya", "kita", "kitalah", "kok", "kurang", "lagi", "lagian", "lah", "lain",
      "lainnya", "lalu", "lama", "lamanya", "lanjut", "lanjutnya", "lebih", "lewat", "lima", "luar", "macam", "maka",
      "makanya", "makin", "malah", "malahan", "mampu", "mampukah", "mana", "manakala", "manalagi", "masa", "masalah",
      "masalahnya", "masih", "masihkah", "masing", "masing-masing", "mau", "maupun", "melainkan", "melakukan", "melalui",
      "melihat", "melihatnya", "memang", "memastikan", "memberi", "memberikan", "membuat", "memerlukan", "memihak", "meminta",
      "memintakan", "memisalkan", "memperbuat", "mempergunakan", "memperkirakan", "memperlihatkan", "mempersiapkan",
      "mempersoalkan", "mempertanyakan", "mempunyai", "memulai", "memungkinkan", "menaiki", "menambahkan", "menandaskan",
      "menanti", "menanti-nanti", "menantikan", "menanya", "menanyai", "menanyakan", "mendapat", "mendapatkan", "mendatang",
      "mendatangi", "mendatangkan", "menegaskan", "mengakhiri", "mengapa", "mengatakan", "mengatakannya", "mengenai",
      "mengerjakan", "mengetahui", "menggunakan", "menghendaki", "mengibaratkan", "mengibaratkannya", "mengingat",
      "mengingatkan", "menginginkan", "mengira", "mengucapkan", "mengucapkannya", "mengungkapkan", "menjadi", "menjawab",
      "menjelaskan", "menuju", "menunjuk", "menunjuki", "menunjukkan", "menunjuknya", "menurut", "menuturkan", "menyampaikan",
      "menyangkut", "menyatakan", "menyebutkan", "menyeluruh", "menyiapkan", "merasa", "mereka", "merekalah", "merupakan",
      "meski", "meskipun", "meyakini", "meyakinkan", "minta", "mirip", "misal", "misalkan", "misalnya", "mula", "mulai",
      "mulailah", "mulanya", "mungkin", "mungkinkah", "nah", "naik", "namun", "nanti", "nantinya", "nyaris", "nyatanya",
      "oleh", "olehnya", "pada", "padahal", "padanya", "pak", "paling", "panjang", "pantas", "para", "pasti", "pastilah",
      "penting", "pentingnya", "per", "percuma", "perlu", "perlukah", "perlunya", "pernah", "persoalan", "pertama",
      "pertama-tama", "pertanyaan", "pertanyakan", "pihak", "pihaknya", "pukul", "pula", "pun", "punya", "rasa", "rasanya",
      "rata", "rupanya", "saat", "saatnya", "saja", "sajalah", "saling", "sama", "sama-sama", "sambil",
      "sampai-sampai", "sampaikan", "sana", "sangat", "sangatlah", "satu", "saya", "sayalah", "se", "sebab", "sebabnya",
      "sebagai", "sebagaimana", "sebagainya", "sebagian", "sebaik", "sebaik-baiknya", "sebaiknya", "sebaliknya", "sebanyak",
      "sebegini", "sebegitu", "sebelum", "sebelumnya", "sebenarnya", "seberapa", "sebesar", "sebetulnya", "sebisanya",
      "sebuah", "sebut", "sebutlah", "sebutnya", "secara", "secukupnya", "sedang", "sedangkan", "sedemikian", "sedikit",
      "sedikitnya", "seenaknya", "segala", "segalanya", "segera", "seharusnya", "sehingga", "seingat", "sejak", "sejauh",
      "sejenak", "sejumlah", "sekadar", "sekadarnya", "sekali", "sekali-kali", "sekalian", "sekaligus", "sekalipun",
      "sekarang", "sekarang", "sekecil", "seketika", "sekiranya", "sekitar", "sekitarnya", "sekurang-kurangnya", "sekurangnya",
      "sela", "selain", "selaku", "selalu", "selama", "selama-lamanya", "selamanya", "selanjutnya", "seluruh", "seluruhnya",
      "semacam", "semakin", "semampu", "semampunya", "semasa", "semasih", "semata", "semata-mata", "semaunya", "sementara",
      "semisal", "semisalnya", "sempat", "semua", "semuanya", "semula", "sendiri", "sendirian", "sendirinya", "seolah",
      "seolah-olah", "seorang", "sepanjang", "sepantasnya", "sepantasnyalah", "seperlunya", "seperti", "sepertinya", "sepihak",
      "sering", "seringnya", "serta", "serupa", "sesaat", "sesama", "sesampai", "sesegera", "sesekali", "seseorang", "sesuatu",
      "sesuatunya", "sesudah", "sesudahnya", "setelah", "setempat", "setengah", "seterusnya", "setiap", "setiba", "setibanya",
      "setidak-tidaknya", "setidaknya", "setinggi", "seusai", "sewaktu", "siap", "siapa", "siapakah", "siapapun", "sini",
      "sinilah", "soal", "soalnya", "suatu", "sudah", "sudahkah", "sudahlah", "supaya", "tadi", "tadinya", "tahu", "tahun",
      "tak", "tambah", "tambahnya", "tampak", "tampaknya", "tandas", "tandasnya", "tanpa", "tanya", "tanyakan", "tanyanya",
      "tapi", "tegas", "tegasnya", "telah", "tempat", "tengah", "tentang", "tentu", "tentulah", "tentunya", "tepat", "terakhir",
      "terasa", "terbanyak", "terdahulu", "terdapat", "terdiri", "terhadap", "terhadapnya", "teringat", "teringat-ingat",
      "terjadi", "terjadilah", "terjadinya", "terkira", "terlalu", "terlebih", "terlihat", "termasuk", "ternyata",
      "tersampaikan", "tersebut", "tersebutlah", "tertentu", "tertuju", "terus", "terutama", "tetap", "tetapi", "tiap", "tiba",
      "tiba-tiba", "tidak", "tidakkah", "tidaklah", "tiga", "tinggi", "toh", "tunjuk", "turut", "tutur", "tuturnya", "ucap",
      "ucapnya", "ujar", "ujarnya", "umum", "umumnya", "ungkap", "ungkapnya", "untuk", "usah", "usai", "waduh", "wah",
      "wahai", "waktu", "waktunya", "walau", "walaupun", "wong", "yaitu", "yakin", "yakni", "yang"
  ]

    attr_accessor :tf, :idf, :tf_idf

    def initialize(docs, limit, exclude_stop_words)

      @docs = split_docs(docs)
      @tf = []
      @idf = {}
      @tf_idf = []
      @docs_size = @docs.size
      compute_tf_and_idf
      compute_tf_idf(limit,exclude_stop_words)

    end

    def split_docs(docs)

      splitted_docs = []
      docs.each do |d|
        begin
          splitted_docs << d.downcase.gsub(/[^a-z0-9]/,' ').split(/\s+/)
        rescue
        end
      end
      splitted_docs
    end


    def compute_tf_and_idf

      @docs.each do |words|

        terms_freq_in_words = words.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
        @tf.push(terms_freq_in_words)
        distinct_words = words.uniq
        distinct_words.each do |w|
          if ( @idf.has_key?(w) )
            y = @docs_size / ( 10**(@idf[w]) )
            y += 1
            @idf[w] = Math.log10(@docs_size / y)
          else
            @idf[w] = Math.log10(@docs_size)
          end
        end
      end


      def compute_tf_idf(limit,exlude_stop_words)

        @tf.each do |tf_freq|
          tfidf = Hash.new(0)
          tf_freq.each do |key,value|
            tfidf[key] = @idf[key] * value
          end
          if (exlude_stop_words == true)
            tfidf.reject!{ |k| STOP_WORDS_FR.include?(k) == true }
            tfidf.reject!{ |k| STOP_WORDS_EN.include?(k) == true }
            tfidf.reject!{ |k| STOP_WORDS_ID_V2.include?(k) == true }
          end
          tfidf = Hash[tfidf.sort_by { |k,v| -v }[0..limit-1]]
          @tf_idf.push(tfidf)
        end
      end

    end
  end

end
