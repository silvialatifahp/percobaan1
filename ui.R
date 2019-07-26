library(shiny)
library(shinydashboard)
library(DT)
library(png)
library(readxl)
library(ggplot2)
library(cluster)
library(dplyr)

shinyUI(
  dashboardPage(
    skin = "green",
    dashboardHeader(title = "Sistem Informasi Kesehatan Kota Bandung", titleWidth = 420),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Beranda", tabName = "home", icon = icon("home")),
        menuItem("Definisi K-Means",tabName = "pengertian", icon = icon("book-reader")),
        menuItem("Pengujian", tabName = "kmeans", icon = icon("database"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "home",
          sidebarLayout(
            sidebarPanel(
              br(),
              br(),
              h3("Sistem Informasi Dinas Kesehatan Kota Bandung"),
              p(
                "Jl. Supratman No. 73",
                "Cibeunying Kaler, Kota Bandung, Jawa Barat 40122"
              ),
              p("Telepon  : (022) 872-44572"),
              p("Email    : dinaskesehatankotabdg@gmail.com"),
              br(),
              br(),
              br()
            ), #sidebarpanel
            mainPanel(
              width = 8,
              h1(strong("Sistem Informasi Dinas Kesehatan Kota Bandung")),
              p(
                "Kesehatan menurut Kementerian Kesehatan yang ditulis didalam UU No. 23 Tahun 1992  ",
                "adalah keadaan normal dan sejahtera anggota tubuh, sosial, dan jiwa pada seseorang
                yang dapat melakukan aktifitas tanpa gangguan. ",
                "Untuk menyelenggarakan pendidikan yang
                bermutu diperlukan biaya yang cukup besar. Oleh karena itu, bagi setiap peserta didik
                pada setiap satuan pendidikan berhak mendapatkan biaya pendidikan bagi mereka yang
                orang tuanya tidak mampu membiayai pendidikannya, dan berhak mendapatkan beasiswa
                bagi mereka yang berprestasi."
              ),
              h2("Hak Kesehatan"),
              p("Hak setiap warga Indonesia memperoleh kesehatan
                telah dijamin berdasarkan Undang-Undang Dasar 1945, Undang-Undang Nomor 36
                tahun 2009 tentang kesehatan, dan Undang-Undang Nomor 39 Tahun 1999 tentang Hak
                Asasi Manusia dan Konvenan Internasional tentang Hak Ekonomi, Sosial, dan Budaya
                yang telah diratifikasi oleh Undang-Undang Nomor 12 Tahun 2005. "),
              p("Adapun hak-hak kesehatan yang dapat diperoleh masyarakat adalah sebagai berikut:"),
              p("1. Hak memperoleh akses atas sumber daya di bidang kesehatan;"),
              p("2. Hak memperoleh pelayanan kesehatan yang aman, bermutu, dan terjangkau;"),
              p("3. Berhak secara mandiri dan bertanggung jawab menentukan sendiri pelayanan
                kesehatan yang diperlukan bagi dirinya;"),
              p("4. Berhak mendapatkan lingkungan yang sehat bagi pencapaian derajat kesehatan;"),
              p("5. Berhak mendapatkan informasi dan edukasi tentang kesehatan yang seimbang
                pendidikan kepada peserta didik yang orang tua atau walinya tidak mampu
                dan bertanggung jawab.")
              ) #mainPanel
              ) #sidebarlayout
              ), #tabitem
        tabItem(
          tabName = "pengertian",
          h2("Pengertian K-Means Clustering"),
          p(
            "K-Means Clustering adalah salah satu metode clustering yang umum digunakan dan sederhana",
            "K-Means bekerja mencari partisi terdekat dengan titik pusat yang telah ditentukan secara
            random atau acak"
          ),
          h2("Proses K-Means:"),
          br(),
          img(src = "fchart.png", height = 724, width = 567, align ="center"),
          br(),
          br(),
          p("1. Tentukan berapa banyak data yang harus dibagi;"),
          p("2. Alokasikan data yang telah dikumpulkan kedalam cluster secara random;"),
          p("3. Tentukan pusat cluster (centroid) dan alokasikan data kemasing-masing centroid terdekat;"),
          p("4. Perbaharui lokasi centroid ke nilai baru centroid;"),
          p("5. Ulangi langkah 3 dan 4 hingga clustering menjadi terpusat ke satu
            centroid dan stabil (sudah tidak ada perpindahan data);")
          ),
        tabItem(
          tabName = "kmeans",
          fluidRow(
            tabBox(
              width = 12,
              fileInput("path_df_raw",
                        "Unggah file(.xlsx)",
                        multiple = TRUE,
                        accept = c(
                          "text/xlsx",
                          "text/extensible-stylesheet-language, text/plain",
                          ".xlsx"
                        )
              ),
              helpText("File maksimal 5MB")
            ),
            tabBox(
              width = 12,
              tabPanel(
                "Data Uji",
                br(),
                DT::dataTableOutput("df_raw")
              ),
              tabPanel(
                "K-means",
                br(),
                sidebarLayout(
                  sidebarPanel(
                    selectInput("var1",
                                "Pilih Variabel 1",
                                choices = NULL
                    ), #selectinput
                    selectInput("var2",
                                "Pilih Variabel 2",
                                choices = NULL
                    ), #selectinput
                    numericInput("n_clusters",
                                 "Berapa Banyak Cluster:",
                                 value = 2,
                                 min = 2,
                                 max = 9,
                                 step = 1
                    ),
                    actionButton(
                      "analyse",
                      "Analisis"
                    )
                  ),
                  mainPanel(
                    plotOutput("plot_kmeans"),
                    downloadButton("download_plot","Download Hasil Plotting"),
                    br(),
                    hr(),
                    br(),
                    DT::dataTableOutput("df_kmeans"))
                )
              )#tabpanelkmeans
            ) #tabbox
          ) #fluidroww
        ) #tabitem
          ) #tabitems
          ) #dashboardbody
    ) #dashboardpage
  ) #shinyUI
