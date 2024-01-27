<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<%
   String ctxPath = request.getContextPath();
%>

    
<style type="text/css">

#mycontent {
   height: 945px;
}

form {
   margin: 3% 0 5% 0;
}

.highcharts-figure,
.highcharts-data-table table {
    min-width: 360px;
    max-width: 800px;
    margin: 1em 0 1em 3%;
}

.highcharts-data-table table {
    font-family: Verdana, sans-serif;
    border-collapse: collapse;
    border: 1px solid #ebebeb;
    margin: 10px auto;
    text-align: center;
    width: 100%;
    max-width: 500px;
}

.highcharts-data-table caption {
    padding: 1em 0;
    font-size: 1.2em;
    color: #555;
}

.highcharts-data-table th {
    font-weight: 600;
    padding: 0.5em;
}

.highcharts-data-table td,
.highcharts-data-table th,
.highcharts-data-table caption {
    padding: 0.5em;
}

.highcharts-data-table thead tr,
.highcharts-data-table tr:nth-child(even) {
    background: #f8f8f8;
}

.highcharts-data-table tr:hover {
    background: #f1f7ff;
}

#container h4 {
    text-transform: none;
    font-size: 14px;
    font-weight: normal;
}

#container p {
    font-size: 13px;
    line-height: 16px;
}

@media screen and (max-width: 600px) {
    #container h4 {
        font-size: 2.3vw;
        line-height: 3vw;
    }

    #container p {
        font-size: 2.3vw;
        line-height: 3vw;
    }
}

img {
   width: 40px;
   height: 42px;
}

</style>




<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/highcharts.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/sankey.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/organization.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/accessibility.js"></script>

<figure class="highcharts-figure">
    
    <div style="margin-left: 160px;">
    <form name="searchFrm">
         <select name="searchType" id="searchType" style="height: 30px;">
            <option value="">부서를 선택하세요</option>
            <option value="company">회사 조직도</option>
            <option value="executive">사장 및 부서장</option>
            <c:if test="${not empty requestScope.deptList}">
               <c:forEach var="dept" items="${requestScope.deptList}">
                  <option value="${dept.department_id}">${dept.department_name}</option>
               </c:forEach>
            </c:if>
            
            
         </select>
      </form>
    
    <div id="container" style="width: 1400px;"></div>
    </div>
</figure>



<script type="text/javascript">

$(document).ready(function(){
   
   $("select#searchType").change(function(e){
      func_select($(this).val());
   });
   
   $("select#searchType").val("company").trigger("change");
   
}); // end of $(document).ready(function(){})--------------------------

function func_select(searchTypeVal){
   
   $.ajax({
      url: "<%= ctxPath%>/chart/deptList.gw",
      dataType: "json",
      success: function (json) {

         switch (searchTypeVal) {
            case "":
               $("div#container").empty();
               $("div.highcharts-data-table").empty();
               break;
         
            case "company":
               $.ajax({
                  url:"<%= ctxPath%>/chart/company.gw",
                  dataType:"json",
                  success:function(json){
                     
                     $("div#container").empty();
                     $("div.highcharts-data-table").empty();
                     
                     let CEOArr = [];
                     let managerArr = [];
                     let t_managerArr = [];
                     let employeeArr = [];
                
                     for(let i=0; i<json.length; i++) {
                        const employee_id = json[i].employee_id;
                        const t_manager_id = json[i].t_manager_id;
                        const manager_id = json[i].manager_id;
                         
                        if(employee_id == t_manager_id && t_manager_id == manager_id) {
                           CEOArr.push(json[i].job_name);
                           console.log(CEOArr);
                        }
                        else if(employee_id == manager_id ) {
                           managerArr.push(json[i].job_name);
                        }
                        else if(employee_id == t_manager_id ) {
                           t_managerArr.push(json[i].job_name);
                        }
                        else {
                           employeeArr.push(json[i].job_name);
                        }
                        
                     }// end of for-------------------------------
            
                     const ceoarr = [];
                     for(let i=0; i<managerArr.length; i++){
                        let obj = [
                                 CEOA= CEOArr,
                                 manager= managerArr[i]
                                ];
                        ceoarr.push(obj);
                     }// end of for----------------
            
                     for(let i = 0; i < managerArr.length; i++) {
                        let deptname = managerArr[i].substring(0, 2);
                        
                        for(let j = 0; j < t_managerArr.length; j++) {
                         const tname = t_managerArr[j].substring(0, 2);
                        
                           if(tname === deptname) {
                              let obj = [
                                       marArr= managerArr[i],
                                       t_marr= t_managerArr[j]
                                      ];
                              ceoarr.push(obj);
                           }
                        }// end of for----------------
                     }// end of for----------------
                
                     let resultArr = [];
                     for(let i=0; i<json.length; i++){
                         let obj = {
                               id:json[i].job_name,
                            };
                  
                            resultArr.push(obj);
                            
                      }// end of for-------------------
                      
                      console.log(ceoarr);
                      
                     ////////////////////////////////////////////////////////
                     Highcharts.chart('container', {
                        chart: {
                           height: 750,
                           inverted: true
                        },
                        title: {
                           text: 'MTS 조직도'
                        },
                        accessibility: {
                           point: {
                              descriptionFormatter: function (point) {
                                 var nodeName = point.toNode.name,
                                 nodeId = point.toNode.id,
                                 nodeDesc = nodeName === nodeId ? nodeName : nodeName + ', ' + nodeId,
                                 parentDesc = point.fromNode.id;
                                 return point.index + '. ' + nodeDesc + ', reports to ' + parentDesc + '.';
                              }
                           }
                        },
                        series: [{
                           type: 'organization',
                           name: 'MTS',
                           keys: ['from', 'to'],
                           data: ceoarr,
                           levels: [{
                                  level: 0,
                                  color: '#ff8080'
                              }, {
                                  level: 1,
                                  color: '#99e6ff'
                              }, {
                                  level: 2,
                                  color: '#adebad'
                              }],
                           nodes: resultArr,
                           colorByPoint: false,
                           color: '#007ad0',
                           dataLabels: {
                              color: 'white'
                           },
                           borderColor: 'white',
                           nodeWidth: 65
                        }],
                        tooltip: {
                           outside: true
                        },
                        exporting: {
                           allowHTML: true,
                           sourceWidth: 800,
                           sourceHeight: 600
                        }
                     });
                     ////////////////////////////////////////////////////////
                  },
                  error: function(request, status, error){
                     alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                  }
               });
                  break;
                
            case "executive":
            $.ajax({
               url:"<%= ctxPath%>/chart/executive.gw",
               dataType:"json",
               success:function(json){
                      
                   $("div#container").empty();
                   $("div.highcharts-data-table").empty();
                   
                    let CEOArr = [];
                    let managerArr = [];
                    let t_managerArr = [];
                    let employeeArr = [];
                       
                   for(let i=0; i<json.length; i++) {
                      const employee_id = json[i].employee_id;
                      const t_manager_id = json[i].t_manager_id;
                      const manager_id = json[i].manager_id;
                          
                      if(employee_id == t_manager_id && t_manager_id == manager_id) {
                         CEOArr.push(json[i].job_name);
                      }
                      else if(employee_id == manager_id ) {
                         managerArr.push(json[i].job_name);
                      }
                      else if(employee_id == t_manager_id ) {
                         t_managerArr.push(json[i].job_name);
                      }
                      else {
                         employeeArr.push(json[i].job_name);
                      }
                      
                   }// end of for-------------------------------
                   
                   const ceoarr = [];
                   for(let i=0; i<managerArr.length; i++){
                      let obj = [
                               CEOA= CEOArr[0],
                               manager= managerArr[i]
                              ];
                      ceoarr.push(obj);
                   }// end of for----------------
                       
                   let resultArr = [];
                   for(let i=0; i<json.length; i++) {
                      let obj = {
                               id: json[i].job_name,
                               title: json[i].job_name,
                               name: json[i].name,
                               image: '<%= ctxPath%>/resources/images/empImg/'+json[i].photo
                              };
                      resultArr.push(obj);
                   }// end of for-------------------------------
                   
                   ////////////////////////////////////////////////////////
                   Highcharts.chart('container', {
                      chart: {
                         height: 750,
                         inverted: true
                      },
                      title: {
                         text: 'MTS 조직도'
                      },
                      accessibility: {
                         point: {
                            descriptionFormatter: function (point) {
                               var nodeName = point.toNode.name,
                               nodeId = point.toNode.id,
                               nodeDesc = nodeName === nodeId ? nodeName : nodeName + ', ' + nodeId,
                               parentDesc = point.fromNode.id;
                               return point.index + '. ' + nodeDesc + ', reports to ' + parentDesc + '.';
                            }
                         }
                      },
                      series: [{
                         type: 'organization',
                         name: 'MTS',
                         keys: ['from', 'to'],
                         data: ceoarr,
                         levels: [{
                               level: 0,
                               color: '#ff8080'
                           }, {
                               level: 1,
                               color: '#99e6ff'
                           }],
                         nodes: resultArr,
                         colorByPoint: false,
                         color: '#007ad0',
                         dataLabels: {
                            color: 'white'
                         },
                         borderColor: 'white',
                         nodeWidth: 65
                      }],
                      tooltip: {
                         outside: true
                      },
                      exporting: {
                         allowHTML: true,
                         sourceWidth: 800,
                         sourceHeight: 600
                      }
                   });
                   ////////////////////////////////////////////////////////
               },
               error: function(request, status, error){
                  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
               }
            });
               break;

            default:
               for (let i = 0; i < json.length; i++) {
                  if (searchTypeVal === json[i].department_id.toString()) {
                          
                     $.ajax({
                        url:"<%= ctxPath%>/chart/dept.gw",
                        data: {searchTypeVal: searchTypeVal},
                        dataType:"json",
                        success:function(json2){
                             
                           $("div#container").empty();
                           $("div.highcharts-data-table").empty();
                           
                           let deptList = [];
                           for(let i=0; i<json2.length; i++){
                              if(json2[i].department_id == searchTypeVal){
                                 deptList.push(json2[i]);
                              }
                           }
                         //   console.log(deptList);
                             
                           let CEOArr = [];
                           let managerArr = [];
                           let t_managerArr = [];
                           let employeeArr = [];
                             
                           for(let i=0; i<deptList.length; i++) {
                              const employee_id = deptList[i].employee_id;
                              const t_manager_id = deptList[i].t_manager_id;
                              const manager_id = deptList[i].manager_id;
                                  
                              if(employee_id == t_manager_id && t_manager_id == manager_id) {
                                 CEOArr.push(deptList[i].job_name);
                              }
                              else if(employee_id == manager_id ) {
                                 managerArr.push({job_name: deptList[i].job_name, employee_id: deptList[i].employee_id });
                              }
                              else if(employee_id == t_manager_id ) {
                                 t_managerArr.push({job_name: deptList[i].job_name, employee_id: deptList[i].employee_id });
                              }
                              else {
                                 employeeArr.push({job_name: deptList[i].job_name, employee_id: deptList[i].employee_id });
                              }
                           }// end of for-------------------
                           
                             const ceoarr = [];
                             if(deptList.length == 1){
                                for(let i=0; i<deptList.length; i++) {
                                   
                                   let obj = [
                                      marArr= deptList[i].job_name
                                     ];
                                   
                                   ceoarr.push(obj);
                                       
                                }// end of for----------------
                             }
                             else {
                              for(let i = 0; i < managerArr.length; i++) {
                                 let deptname = managerArr[i].job_name.substring(0, 2);
                                 
                                 for(let j = 0; j < t_managerArr.length; j++) {
                                  const tname = t_managerArr[j].job_name.substring(0, 2);
                                 
                                    if(tname === deptname) {
                                       let obj = [
                                                marArr= managerArr[i].employee_id,
                                                t_marr= t_managerArr[j].employee_id
                                               ];
                                       ceoarr.push(obj);
                                    }
                                 }// end of for----------------
                              }// end of for----------------
                           
                              for(let i = 0; i < t_managerArr.length; i++) {
                                 const index = t_managerArr[i].job_name.indexOf(' ');
                                 const tname = t_managerArr[i].job_name.substring(0, index + 1);
                                   
                                 for(let j = 0; j < employeeArr.length; j++) {
                                    const index = employeeArr[j].job_name.indexOf(' ');
                                    const ename = employeeArr[j].job_name.substring(0, index + 1);
                                    
                                    if(ename === tname) {
                                       let obj = [
                                                marArr= t_managerArr[i].employee_id,
                                                t_marr= employeeArr[j].employee_id
                                               ];
                                       ceoarr.push(obj);
                                    }
                                 }// end of for----------------
                              } // end of for----------------
                             }
                             
                             let resultArr = [];
                             for(let i=0; i<deptList.length; i++) {
                                let obj = {
                                         id: deptList[i].employee_id,
                                         title: deptList[i].job_name,
                                         name: deptList[i].name,
                                         image: '<%= ctxPath%>/resources/images/empImg/'+deptList[i].photo
                                        };
                                resultArr.push(obj); 
                             }// end of for-------------------------------
                             
                         //   console.log(ceoarr);
                         //   console.log(resultArr);
                             
                           ////////////////////////////////////////////////////////
                             Highcharts.chart('container', {
                                chart: {
                                   height: 750,
                                   inverted: true
                                },
                                title: {
                                   text: 'MTS 조직도'
                                },
                                accessibility: {
                                   point: {
                                      descriptionFormatter: function (point) {
                                         var nodeName = point.toNode.name,
                                         nodeId = point.toNode.id,
                                         nodeDesc = nodeName === nodeId ? nodeName : nodeName + ', ' + nodeId,
                                         parentDesc = point.fromNode.id;
                                         return point.index + '. ' + nodeDesc + ', reports to ' + parentDesc + '.';
                                      }
                                   }
                                },
                                series: [{
                                   type: 'organization',
                                   name: 'MTS',
                                   keys: ['from', 'to'],
                                   data: ceoarr,
                                   levels: [{
                                         level: 0,
                                         color: '#99e6ff'
                                     }, {
                                         level: 1,
                                         color: '#adebad'
                                     }, {
                                         level: 2,
                                         color: '#dfbf9f'
                                     }],
                                   nodes: resultArr,
                                   colorByPoint: false,
                                   color: '#007ad0',
                                   dataLabels: {
                                      color: 'white'
                                   },
                                   borderColor: 'white',
                                   nodeWidth: 65
                                }],
                                tooltip: {
                                   outside: true
                                },
                                exporting: {
                                   allowHTML: true,
                                   sourceWidth: 800,
                                   sourceHeight: 600
                                }
                             });
                             ////////////////////////////////////////////////////////
                        },
                        error: function(request, status, error){
                           alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                        }
                     });
                     break;
                  }
               }
                   break;
           }
       },
       error: function (request, status, error) {
           alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
       }
   });
         
         
      
   
   
   
}// end of function func_select(searchTypeVal)-------------------


   
</script>






