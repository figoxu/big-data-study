package com.example;

import org.apache.spark.sql.SparkSession;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import java.util.Arrays;
import java.util.Map;
import org.apache.spark.SparkConf;

public class WordCount {
    public static void main(String[] args) {
        SparkConf conf = new SparkConf()
                .setAppName("Word Count");
        // 移除setMaster配置，让它从spark-submit命令中获取

        JavaSparkContext sc = new JavaSparkContext(conf);
        
        // 创建测试数据
        JavaRDD<String> lines = sc.parallelize(Arrays.asList(
                "Hello Spark",
                "Hello World",
                "Welcome to Spark"
        ));

        // 执行单词计数
        JavaRDD<String> words = lines.flatMap(line -> Arrays.asList(line.split(" ")).iterator());
        Map<String, Long> wordCounts = words.countByValue();

        // 打印结果
        wordCounts.forEach((word, count) -> System.out.println(word + ": " + count));

        // 关闭SparkSession
        sc.stop();
    }
}