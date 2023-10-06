<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "uts_api";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Koneksi ke database gagal: " . $conn->connect_error);
}
$method = $_SERVER["REQUEST_METHOD"];
if ($method === "GET") {
    // Mengambil data belanja
    $sql = "SELECT * FROM belanja";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $belanja = array();
        while ($row = $result->fetch_assoc()) {
            $belanja[] = $row;
        }
        echo json_encode($belanja);
    } else {
        echo "Data belanja kosong.";
    }
}
if ($method === "POST") {
    // Menambahkan data belanja
    $data = json_decode(file_get_contents("php://input"), true);
    $nama_barang = $data["nama_barang"];
    $jumlah = $data["jumlah"];
    $harga = $data["harga"];
    $sql = "INSERT INTO belanja (nama_barang, jumlah, harga) VALUES ('$nama_barang', '$jumlah', '$harga')";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
        //echo "Berhasil tambah data";
    } else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "PUT") {
    // Memperbarui data belanja
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $nama_barang = $data["nama_barang"];
    $jumlah = $data["jumlah"];
    $harga = $data["harga"];
    $sql = "UPDATE belanja SET nama_barang='$nama_barang', jumlah='$jumlah', harga='$harga' WHERE id=$id";

    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
        //echo "Berhasil tambah data";
    } else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "DELETE") {
    // Menghapus data belanja
    $id = $_GET["id"];
    $sql = "DELETE FROM belanja WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
    } else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
$conn->close();