package com.tony.demo.thecastlecompany;


import java.util.Arrays;
import java.util.Collections;
import java.util.List;


/**
 * Created by Tony on 2017-04-22.
 */

public class TheCastleCompany {

    public static Integer[] generateIntegerArray(){
        int maxSize = 6;   // set the default length for array
        int maxValue = 100;   // the high of peek
        Integer[] integerArray = new Integer[maxSize];
        for (int i = 0; i < maxSize; i ++){
            Integer random = (int) (Math.random() * maxValue + 1);
            integerArray[i] = random;
            System.out.print(random +",");
        }
        return integerArray;
        //or use enclosed returns for other testings
        //return new Integer[]{3,3,3};
        //return new Integer[]{6};
        //return null;
    }

    public static int buildCastle( Integer[] intLand){
        int result = 0;
        if(intLand == null){return result;}
        int intMapSize = intLand.length;
        if(intMapSize == 0) return result;
        if(intMapSize == 1) return 1;  // flat
        int intLeftPoint;
        boolean goingUP = false;
        List<Integer> intLandMap = Arrays.asList(intLand);
        if (Collections.max(intLandMap) == Collections.min(intLandMap)){
            return 1; // flat
        }
        intLeftPoint = intLandMap.get(0);
        for (int i=1; i < intMapSize; i++){
            int intRightPoint = intLandMap.get(i);
            if (intLeftPoint < intRightPoint ){ // going up
                if (!goingUP) {
                    result++; // build castle on valley
                }
                goingUP = true;
            }else if (intLeftPoint > intRightPoint) { // going down
                if (goingUP) {
                    result++; // build castle on peek
                }else{
                    if(i == 1){
                        result++; // build a castle at start
                    }
                }
                goingUP = false;
            }
            intLeftPoint = intRightPoint;
        }
        result = result + 1;  // for end point in array
        return result;
    }
}
