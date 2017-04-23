package com.tony.demo.thecastlecompany;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void buildCastle(View view){
        Integer[] map = TheCastleCompany.generateIntegerArray();
        int res = TheCastleCompany.buildCastle(map);
        System.out.println("result:"+res);
    }
}
