use strict;
use warnings;
use Time::Piece;

my $startFlag = "false";
my $SF1 = "";
my $SF2 = "";
my $INV1 = "";
my $INV2 = "";
my $NUMS = "";
my $insString = "";
my $record;
my @nums1;
my $qty1;
my $myQty1;
my $myQty2;
my $prod1;
my $prod2;
my $myExpDate1;
my $myExpDate2;
my $myShipDate1;
my $myShipDate2;
my $myManufacturer1;
my $myManufacturer2 = "";
my $insStringMF = "";
my $insStringMFPart1;
#my $flagMF = "false";
my $myManufacturerAddr;
my $myManufacturerAddr2;
my $loopCounter = 0;
my $myMFCityState2 = "";
my $myMFCityState = "";
my $prodFlag = "false";
my $prfCounter = 0;
my $INVFlag = "false";
my $infoFlag = "false";
my $orderFlag = "false";
my $invStr = "";
my $partStr = "";
my $prodString = "";
#my @itm;
my $itm_count = "";
my $manufactureFlag = "false";
#my $insertString = "INSERT INTO inbound_record (tp_name, tp_inv_num, ndc_num, lot_num, tp_item_id, qty, current_qty, prod_name, exp_date, prod_desc) VALUES(";
my $insertString = "INSERT INTO inbound_record (tp_name, tp_inv_num, tp_item_id, ndc_num, lot_num, qty, current_qty, prod_name, exp_date, prod_desc) VALUES(";
my $closeStr = "\)\;";
my $tpartner = "Capital Wholesale Drug Company";


open (CHECKBOOK, "585996.txt") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
	my @itm;
	my $strStart = substr $record, 0, 2;
    if ($strStart eq "ST"){
		$startFlag = "true";
		$insString = "";
			#print "The record is: $record the position is: $position\n";
		$orderFlag = "false";
		$manufactureFlag = "false";
	}
    elsif ($strStart eq "SE*"){
            #print $record;
	        #print "end of line item\n";
	    # print "INSERT INTO inbound_record (tp_name, tp_inv_num, ndc_num, lot_num, tp_item_id, qty, current_qty, prod_name, exp_date, prod_desc) " . $insString . "\n";
	  
		$startFlag = "false";
	    $loopCounter = 0;
	    $insString = "";
	    $insStringMF = "";
	    $prodFlag = "false";
		$INVFlag = "false";
		$infoFlag = "false";
		$orderFlag = "false";
		$manufactureFlag = "false";
    }
	
	if($startFlag eq "true"){
		
		my $strStart = substr $record, 0, 3;
		if ($strStart eq "HL*"){
			my $position = index($record, "O");
			if ($position != -1){
				$orderFlag = "true";
					#print "The record is: $record the position is: $position\n";
				$infoFlag = "false";
				$manufactureFlag = "false";	
			}		
		}
		
		my $testINV = substr $record, 0, 7;
		if($testINV eq "REF*IV*"){
	        
			if($orderFlag eq "true"){
				$INVFlag = "true";
				$INV1 = substr $record, 7;
					#print $INV1 . " ";
				my $lenINV1 = length $INV1;
				my $lenINV2 = $lenINV1 - 1;
				$INV2 = substr $INV1, 0, $lenINV2;
				#print " INV: " . $INV2;
				chop($INV2);
				#print "The inv is: $INV2\n"
			}
        }
		
		my $strInfor = substr $record, 0, 3;
		if ($strInfor eq "HL*"){
			my $position = index($record, "I");
			if ($position != -1){
				$infoFlag = "true";
				$orderFlag = "false";
				$insStringMF = "";
					#print "The record is: $record the position is: $position\n";
			}		
		}		
		
		my $testNumbers = substr $record, 0, 4;
		my $loopvalue = 0;
		if($testNumbers eq "LIN*"){
			
			my $position = index($record, "*");
			#print "The position of * is: $position\n";
			my $sub1 = substr $record, $position + 1;
			#print " sub1 is: $sub1 \n";
			my $position2 = index($sub1, "*");
			my $sub2 = substr $sub1, $position2 + 1;
			#print " sub2 is: $sub2 \n";
			my $position3 = index($sub2, "*");
			my $sub3 = substr $sub2, $position3 + 1;
			#print " sub3 is: $sub3 \n";
			$sub3 =~ tr/*/:/;
		    $sub3 =~ tr/~/ /;
			my $cpos1 = index($sub3, ":");
			#print "sub3 is: $sub3";
			#print "cpos1 is: $cpos1\n";
			my $NDC1 = substr $sub3, 0, $cpos1;
			#print "NDC1 is: $NDC1\n";
			my $NDC2 = substr $sub3, $cpos1 + 1;
			#print "NDC2 is: $NDC2";
			my $cpos2 = index($NDC2, ":");
			my $NDC3 = substr $NDC2, $cpos2 + 1;
			#print "NDC3 is: $NDC3";
			my $cpos3 = index ($NDC3, ":");
			#print $cpos3;
			my $NDC4 = substr $NDC3, 0, $cpos3;
			#print "NDC4 is: $NDC4\n";
			my $cpos5 = index($NDC3,":");
			my $NDC5 = substr $NDC3, $cpos5 + 1;
			#print "NDC5 is: $NDC5";
			my $cpos6 = index($NDC5,":");
			my $NDC6 = substr $NDC5, $cpos6 + 1;
			#print "NDC6 is: $NDC6";

			$NDC6 =~ s/^\s+|\s+$//g;
			$prodString = "\"$NDC1\",";
			$prodString = $prodString . "\"$NDC4\",";
			$prodString = $prodString . "\"$NDC6\",";
			#print "$prodString\n";
			if($infoFlag eq "true"){
				
				$prodString = "\"" . $INV2 . "\"\," . $prodString;
				#print "$prodString\n";
			}
		}
		
		my $testQty = substr $record, 0, 3;
	    if($testQty eq "SN1"){
	        
			if($infoFlag eq "true"){
					#print $testQty . " ";
				$qty1 = substr $record, 6;
					#print $qty1 . " ";
				my $indQty1 = index($qty1,"*");
					#print $indQty1 . " ";
				$myQty1 = substr $qty1, 0, $indQty1;
					#print " QTY: " . $myQty1;
				$myQty2 = $myQty1;
				$prodString = $prodString . "\"" . $myQty1 . "\", ";
				$prodString = $prodString . "\"" . $myQty2 . "\", ";
			}
	    }
		
	    my $testProd = substr $record, 0, 9;
	    if($testProd eq "PID*F****"){
			
			if($infoFlag eq "true"){
					#print $testProd . " ";
				$prod1 = substr $record, 9;
					#print $prod1 . " ";
				my $indProd1 = index($prod1,"~");
					#print $indProd1 . " ";
				$prod2 = substr $prod1, 0, $indProd1;
					#print " Product is: " . $prod2;
				$prodString = $prodString . "\"" . $prod2 . "\", ";
			}
	    }
		
		my $testExpDate = substr $record, 0, 8;
	    if($testExpDate eq "DTM*208*"){
	        
			if($infoFlag eq "true"){
					#print $testExpDate . " ";
				$myExpDate1 = substr $record, 8;
					#print $myExpDate1 . " ";
				my $indExpDate1 = index($myExpDate1,"~");
					#print $myExpDate1 . " ";
				$myExpDate2 = substr $myExpDate1, 0, $indExpDate1;
					#print " Exp Date is: " . $myExpDate2 . " "; 
				my $expDate = Time::Piece->strptime($myExpDate2, '%Y%m%d')->strftime('%d-%b-%Y');
					#print " the date is: " . $tstDate . "\n";
				$prodString = $prodString . "\"" . $expDate . "\", ";
				#print "$prodString\n";
			}
		}
			
		my $testManufacturer = substr $record, 0, 6;
	    if($testManufacturer eq "N1*MF*"){
	        #print "I am here\n ";
			$manufactureFlag = "true";
			if($infoFlag eq "true"){
					#print $testManufacturer . " ";
				$myManufacturer1 = substr $record, 6;
					#print $myManufacturer1 . " ";
				my $indManufacturer1 = index($myManufacturer1,"~");
					#print $indManufacturer1 . " ";
				$myManufacturer2 = substr $myManufacturer1, 0, $indManufacturer1;
				$myManufacturer2 = $myManufacturer2 . " ";
					#print " Manufacturer name: " . $myManufacturer2 . " ";
				$insStringMF = $insStringMF . "\"" . $myManufacturer2;
					#$insString = $insString . " " . $insStringMF;
				$prodString = $prodString . $insStringMF;
				#print "$prodString\n";
			}
		    
	    }	
		
		my $testManufacturerAddr = substr $record, 0, 3;
	    if($testManufacturerAddr eq "N3*"){
	        
			if($infoFlag eq "true" and $manufactureFlag eq "true"){
			
					#print $testManufacturerAddr . " ";
				$myManufacturerAddr = substr $record, 3;
					#print $myManufacturerAddr . " ";
				my $indManufacturerAddr = index($myManufacturerAddr,"~");
					#print $indManufacturerAddr . " ";
				$myManufacturerAddr2 = substr $myManufacturerAddr, 0, $indManufacturerAddr;
				$myManufacturerAddr2 = $myManufacturerAddr2 . " ";
					#print " Manufacturer addr: " . $myManufacturerAddr2 . " ";
				$prodString = $prodString . $myManufacturerAddr2;
				#print "$prodString\n";
			}
			#$manufactureFlag = "false";
	    }
		
		my $testMFCityState = substr $record, 0, 3;
	    if($testMFCityState eq "N4*"){
	        
			if($infoFlag eq "true" and $manufactureFlag eq "true"){
					#print $testMFCityState . " ";
				$myMFCityState = substr $record, 3;
					#print $testMFCityState . " ";
				my $indMFCityState = index($myMFCityState,"~");
					#print $indMFCityState . " ";
				$myMFCityState2 = substr $myMFCityState, 0, $indMFCityState;
				$myMFCityState2 = $myMFCityState2 . " ";
				$myMFCityState2 =~ tr/*/:/;
				$myMFCityState2 =~ s/:/ /g;
					#print " Manufacturer city state: " . $myManufacturerAddr2 . " ";
				$myMFCityState2 =~ s/^\s+|\s+$//g;
				$prodString = $prodString . $myMFCityState2 . "\"";
				$prodString =~ s/^\s+|\s+$//g;
				$prodString =  "\"$tpartner\"," . $prodString;
			    #****
				print "$insertString$prodString$closeStr\n";
				
			}
			$manufactureFlag = "false";
	    }
	}
	
}
close(CHECKBOOK);
